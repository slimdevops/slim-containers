# Containers 101 - Networking Part 9: Reverse Proxy

# Introduction

In this workshop we're adding a simple nginx reverse proxy to server our
frontend web app on port 80:

Prerequisites:
  * `docker`
  * `docker-compose`
  * domain(s) with the DNS entries pointing to the location where you will host
    your reverse proxy

## Adding nginx-proxy

We're am making use of the extremely useful [nginx-proxy](https://hub.docker.com/r/jwilder/nginx-proxy/) project.

Adding `nginx-proxy` to our docker-compose file is simple enough:

```yaml
    nginx-proxy:
        image: jwilder/nginx-proxy
        container_name: proxy
        ports:
        - 80:80
        volumes:
        - /var/run/docker.sock:/tmp/docker.sock:ro
        - /etc/nginx/vhost.d
        networks:
        - proxynet
```

This should be fairly self explanatory, `nginx-proxy` exposes port `80` and
mounts the docker socket and a volume for the dynamically generated nginx
configuration.

We also need to add the `proxynet` using the `bridge` driver to the `networks:`
like so:

```yaml
networks:
    photonet:
    proxynet:
        driver: bridge
```

## Connecting the frontend app to the reverse proxy

Adding the following to `frontend:` is all that is required to

```yaml
        depends_on:
        - nginx-proxy
        environment:
        - VIRTUAL_HOST=example.local
        - VIRTUAL_PORT=3000
        networks:
        - proxynet
```

The main requirement here is that the environment variable `VIRTUAL_HOST` must
be specified. This tells the reverse proxy which address will be routed to the
appropriate container.

If your application exposes more than one port then you need to tell the proxy
which port you want to use by setting the environment variable `VIRTUAL_PORT`.
Our PhotoApp only exposes one port which is defined in its Dockerfile, 3000, but
I have included the `VIRTUAL_PORT` in the docker-compose file for completeness.

## Complete docker-compose file

Here is the complete `docker-compose.yml` file:

```yaml
version: '3'
services:
    database:
        container_name: photo_db
        image: postgres:latest
        restart: always
        ports:
        - "5432:5432"
        volumes:
        - ./srv/data/db:/data/db # update to where PG wants data volume
        - ./srv/data/postgres:/var/lib/postgresql/data #update to where PG wants conf file
        #- ./init.sh:/docker-entrypoint-initdb.d/init.sh
        environment:
            POSTGRES_DB: photos
            POSTGRES_USER: docker
            POSTGRES_PASSWORD: test
            PGDATA: /var/lib/postgresql/data

    backend:
        container_name: photo_backend
        image: slimpsv/photo_backend
        restart: always
        depends_on:
        - database
        build: backend/.
        ports:
        - "5000:5000"
        volumes:
        - ./srv/images:/app/static/images # should map to S3 bucket or similar
        - ./srv/data:/app/data # will remove when DB service available
        networks:
        - photonet

    frontend:
        container_name: photo_frontend
        image: slimpsv/photo_frontend
        restart: always
        build: frontend/.
        ports:
        - "3000:3000"
        depends_on:
        - nginx-proxy
        environment:
        - VIRTUAL_HOST=example.local
        - VIRTUAL_PORT=3000
        networks:
        - photonet
        - proxynet

    nginx-proxy:
        image: jwilder/nginx-proxy
        container_name: proxy
        ports:
        - 80:80
        volumes:
        - /var/run/docker.sock:/tmp/docker.sock:ro
        - /etc/nginx/vhost.d
        networks:
        - proxynet

networks:
    photonet:
    proxynet:
        driver: bridge

volumes:
    database:
    backend:
```

## Starting services

**NOTE!** Before bringing up the containers you need to ensure that your DNS
entries point to the location where you will be running these services.

For the purposes of this example I added `example.local` to my local `/etc/hosts`
file:

```
127.0.2.1       example.local   www.example.local
```

Save the `docker-compose.yml` and execute the following to build and run the
containers:

```bash
docker compose up -d --build
```

Check the containers are running with:

```bash
docker ps
```

Stop with:

```bash
docker-compose down
```

If you find that some of the containers are not running then try starting the
services again without passing `-d` to `docker-compose up` this will let you see
the logs of each service and should give you a hint as to what went wrong.

To stop the containers, execute:

```bash
docker-compose down
```

## TLS with Lets Encrypt

For production deployments you will want to enable encryption and the
[nginxproxy/acme-companion](https://hub.docker.com/r/nginxproxy/acme-companion) project
is perfect for the job.

The [README for acme-companion on DockerHub](https://hub.docker.com/r/nginxproxy/acme-companion)
explains what needs to be done to integrate Lets Encrypt in your web app container(s).

### Requirements:
  * Your host *must* be publicly reachable on *both* port `80` and `443`.
  * Check your firewall rules and *do not attempt to block port `80`* as that will prevent `http-01` challenges from completing.
  * For the same reason, you can't use nginx-proxy's `HTTPS_METHOD=nohttp`.
  * The (sub)domains you want to issue certificates for *must* correctly resolve to the host.
  * Your DNS provider must [answer correctly to CAA record requests](https://letsencrypt.org/docs/caa/).
  * If your (sub)domains have AAAA records set, the host must be publicly reachable over IPv6 on port `80` and `443`.

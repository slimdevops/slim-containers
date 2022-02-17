# Containers 101 - Networking Part 3: Databases

# Introduction
# 

## The Plan:
1. Add PostgreSQL container to docker compose 
2. Configure Volumes for database and conf files 
3. Verify that upload data goes to database

# Adding the Postgres Container 
Here's where we start to see the power of containers. Until now, we've had a somewhat cumbersome process of coding an application, then created a Dockerfile to generate an image for the application, built it, ran it, debugged it. 

But we aren't going to build our own database application. We can just use PostgreSQL. 

New Compose File
```
database: 
        container_name: photo_db 
        image: postgres:latest
        restart: always
        ports: 
        - "5432:5432"
        volumes: 
        - ./srv/data/db:/data/db # update to where PG wants data volume
        - ./srv/data/postgres:/var/lib/postgresql/data #update to where PG wants conf file
        - ./init.sh:/docker-entrypoint-initdb.d/init.sh
        environment: 
            POSTGRES_DB: photos
            POSTGRES_USER: docker
            POSTGRES_PASSWORD: test
            PGDATA: /var/lib/postgresql/data
```
# Configuring the Postgres Container 
Handy `init.sql` script. 

```
#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER docker;
    CREATE DATABASE my_project_development;
    GRANT ALL PRIVILEGES ON DATABASE my_project_development TO docker;
EOSQL
```

# Verify upload data 
Adding to `Uploader.vue`
```js
    methods: {
        postUpload() { 
```

```js
let formData = new FormData();
            formData.append('cat', this.category);
            formData.append('pic', this.imageFile);
```
##
## CORS issues

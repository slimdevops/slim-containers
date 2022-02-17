# Dockerfile
# Reference: https://dev.to/rogertorres/first-steps-with-docker-rust-30oi
FROM rust:latest 

#where should I put my files
WORKDIR /home 

# do I compile locally then copy the binary or copy source code and then compile?
COPY ./ ./

# copy then compile 
RUN cargo build --release 

# CMD? ENTRYPOINT? Both? Which version (not the .exe I compiled locally)
CMD [ "./target/release/guessing-game" ]

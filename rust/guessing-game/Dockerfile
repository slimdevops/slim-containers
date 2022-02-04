# Dockerfile
# Reference: https://dev.to/rogertorres/first-steps-with-docker-rust-30oi
FROM rust:latest 

# copy the files (cargo.toml and src) into container
COPY ./ ./

# 
RUN cargo build --release 

# CMD? ENTRYPOINT? Both? Which version (not the .exe I compiled locally)
CMD [ "./target/release/guessing-game" ] 

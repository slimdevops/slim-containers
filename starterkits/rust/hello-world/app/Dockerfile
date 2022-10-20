FROM rust:latest 

COPY ./ ./

RUN cargo build --release

EXPOSE 7878

CMD ["./target/release/slim-cloud-native-webserver"]
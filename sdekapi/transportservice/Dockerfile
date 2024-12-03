FROM rust as build
COPY . /code
WORKDIR /code
RUN cargo build --release
ENTRYPOINT [ "./target/release/transportservice" ]
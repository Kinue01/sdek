FROM rust AS build
COPY . /code
WORKDIR /code
RUN cargo build --release
WORKDIR /code/target/release
ENTRYPOINT [ "./userreadservice" ]
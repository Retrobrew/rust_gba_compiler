FROM rust:latest
RUN rustup install nightly
RUN rustup +nightly component add rust-src
RUN apt update && apt install binutils-arm-none-eabi
RUN cargo install cargo-make
RUN cargo install gbafix
COPY make.sh /
RUN chmod +x /make.sh
VOLUME /data
ENTRYPOINT ["sh -c ./make.sh"]
FROM rust:latest
RUN apt update && apt install -y binutils-arm-none-eabi git bubblewrap
RUN apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
RUN rustup install nightly
RUN rustup +nightly component add rust-src
RUN mkdir -p /data
WORKDIR /data
RUN git clone https://github.com/Retrobrew/gba.git
RUN cd gba && cargo install cargo-make && cargo install gbafix
WORKDIR /data/gba
ENTRYPOINT bwrap --unshare-all --share-net --ro-bind / / --dev-bind /usr/local/rustup/ /usr/local/rustup/ --dev-bind /tmp /tmp --dev-bind /usr/local/cargo/registry/ /usr/local/cargo/registry/ --dev-bind /data /data ./make_example.sh rom

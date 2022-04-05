# GBA Rust compiler in docker container
Add ``rom.rs`` in ``src/`` folder.

## Build
```
docker build -t gba-rust .
```

## Run
```
 docker run -v $PWD/src:/data/gba/examples -v $PWD/target:/data/gba/target gba-rust```
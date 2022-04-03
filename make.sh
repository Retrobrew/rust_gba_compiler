#!/bin/sh
cd /data && cargo build --example rom --release
arm-none-eabi-objcopy -O binary target/thumbv4t-none-eabi/release/examples/rom target/rom.gba
gbafix /data/target/rom.gba
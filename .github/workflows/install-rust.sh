#!/bin/bash -e
################################################################################
##  File:  install-rust.sh
##  Desc:  Install Rust on Ubuntu 22.04
################################################################################

# Environment settings for GitHub Actions or local
export RUSTUP_HOME="$HOME/.rustup"
export CARGO_HOME="$HOME/.cargo"

echo "Installing Rust using rustup..."
curl -fsSL https://sh.rustup.rs | sh -s -- -y --default-toolchain=stable --profile=minimal

# Load Cargo environment
source "$CARGO_HOME/env"

echo "Adding common Rust components..."
rustup component add rustfmt clippy

echo "Installing useful Rust tools..."
cargo install bindgen-cli cbindgen cargo-audit cargo-outdated

echo "Cleaning up Cargo registry..."
rm -rf "${CARGO_HOME}/registry"

echo "Rust installation complete."

#!/usr/bin/env bash

set -ex

FEATURE_SET="unix"
if [[ "${target_platform}" == "osx"* ]]; then
    FEATURE_SET="macos"
    export RUSTFLAGS="$RUSTFLAGS -C link-arg=-Wl,-headerpad_max_install_names"
    export CFLAGS="$CFLAGS -Wl,-headerpad_max_install_names"
    export LDFLAGS="$LDFLAGS -Wl,-headerpad_max_install_names"
else
    export LIBCLANG_PATH="${BUILD_PREFIX}/lib"
fi

export C_INCLUDE_PATH="${PREFIX}/include"

export RUSTFLAGS="${RUSTFLAGS:-} -C linker=${CC}"
cargo build --release --features "${FEATURE_SET}"

# Disabled also by patching GNUmakefile
export SELINUX_ENABLED=0

make PROFILE=Release \
    PREFIX="${PREFIX}" \
    MULTICALL=y \
    CARGO_TARGET_DIR="$(pwd)/target/${CARGO_BUILD_TARGET}" \
    install

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

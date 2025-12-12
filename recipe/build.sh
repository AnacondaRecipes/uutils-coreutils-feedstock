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

# if [[ "${target_platform}" == "linux-"* ]]; then
#     ln -s "${BUILD_PREFIX}/bin/aarch64-conda-linux-gnu-gcc" "${BUILD_PREFIX}/bin/aarch64-linux-gnu-gcc"
#     export PATH="${BUILD_PREFIX}/bin:${PATH}"
# fi

# Disable SELinux-related utilities
# export SKIP_UTILS="selinux"
# export SELINUX_ENABLED=0

make PROFILE=Release \
    PREFIX="${PREFIX}" \
    MULTICALL=y \
    CARGO_TARGET_DIR="${SRC_DIR}/target/${CARGO_BUILD_TARGET}" \
    install

cargo-bundle-licenses --format yaml --output THIRDPARTY.yml

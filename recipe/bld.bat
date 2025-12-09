@echo on
setlocal EnableDelayedExpansion

REM ----------------------------------------------------------------------
REM Workaround: rust pkg broken config:
REM   %BUILD_PREFIX%\.cargo.win\config
REM   Issue:
REM     TOML parse error ... duplicate key `x86_64-pc-windows-msvc`
REM   Deleting it to forcing rust useing default config
REM ----------------------------------------------------------------------
if defined BUILD_PREFIX (
    if exist "%BUILD_PREFIX%\.cargo.win\config" (
        echo [bld.bat] Removing broken Cargo config: "%BUILD_PREFIX%\.cargo.win\config"
        del /f /q "%BUILD_PREFIX%\.cargo.win\config"
    )
    if exist "%BUILD_PREFIX%\.cargo.win\config.toml" (
        echo [bld.bat] Removing broken Cargo config.toml: "%BUILD_PREFIX%\.cargo.win\config.toml"
        del /f /q "%BUILD_PREFIX%\.cargo.win\config.toml"
    )
) else (
    echo [bld.bat] WARNING: BUILD_PREFIX is not set, skipping Cargo config cleanup
)

echo [bld.bat] Running: cargo build --release --features windows
cargo build --release --features windows
if errorlevel 1 (
    echo [bld.bat] ERROR: cargo build failed
    exit /b 1
)

@REM echo [bld.bat] Running: make install
set "UNIX_PREFIX=%LIBRARY_PREFIX:\=/%"
make PROFILE=Release ^
     PREFIX="%UNIX_PREFIX%" ^
     MULTICALL=y ^
     PROG_SUFFIX=.exe ^
     CARGO=true ^
     MANPAGES=n ^
     COMPLETIONS=n ^
     install
if errorlevel 1 (
    echo [bld.bat] ERROR: make install failed
    exit /b 1
)

echo [bld.bat] Running: cargo-bundle-licenses
cargo-bundle-licenses --format yaml --output THIRDPARTY.yml
if errorlevel 1 (
    echo [bld.bat] ERROR: cargo-bundle-licenses failed
    exit /b 1
)

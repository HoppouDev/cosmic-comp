name := 'cosmic-comp'
rootdir := ''
prefix := '/usr'

cargo-target-dir := env('CARGO_TARGET_DIR', 'target')

bin-src := cargo-target-dir / 'release' / name
bin-dst := clean(rootdir / prefix) / 'bin' / name

default: build-release

install:
    install -Dm0755 {{bin-src}} {{bin-dst}}

# Remove Cargo build artifacts
clean:
    cargo clean

# Compile with debug profile
build-debug *args:
    cargo build {{args}}

# Compile with release profile
build-release *args: (build-debug '--release' args)

# Check for errors and linter warnings
check *args:
    cargo clippy --all-features {{args}} -- -W clippy::pedantic

# Run the application for testing purposes
run *args:
    env RUST_LOG=debug RUST_BACKTRACE=full cargo run --release {{args}}

# Run `cargo test`
test:
    cargo test
### Rust AWS Lambda Tutorial

This repository hosts the code for my [Rust AWS Lambda Tutorial](https://medium.com/@bernardo.belchior1/running-rust-natively-in-aws-lambda-and-testing-it-locally-57080421426d), using [rust-aws-lambda](https://github.com/srijs/rust-aws-lambda) and [docker-lambda](https://github.com/lambci/docker-lambda). It also includes a way of testing the function locally, so you don't have to provision an AWS Lambda Function to run your program, reducing the feedback loop.

## Compiling

A specific Rust target must be installed, and it can be done as follows:

`$ rustup target add x86_64-unknown-linux-musl`

The `musl-gcc` package must also be installed. 
On Ubuntu, it would be done as follows:

`$ apt-get install musl`

On Mac, it can be done using this brew formula:

`$ brew install FiloSottile/musl-cross/musl-cross`

On Mac, yoiu will need to tell Cargo where to find the linker. 
You can place the following into your projects .cargo/config or configure it globally in your ~/.cargo/config

`[target.x86_64-unknown-linux-musl]
linker = "x86_64-linux-musl-gcc"`

After installing the target and `musl-gcc`, compiling is only a matter of executing the cargo build command:

`$ cargo build --target x86_64-unknown-linux-musl`

In case you want to compile a release version, you must add the `--release` flag:

`$ cargo build --target x86_64-unknown-linux-musl --release`

Cross-compiling on Mac:
The .cargo/config configuration above tells Cargo what linker to use, but you also need to tell build scripts what compiler to use. To do so you need to use the environment variable `CC_x86_64_unknown_linux_musl`. You can do this for all shells using:

`$ export CC_x86_64_unknown_linux_musl="x86_64-linux-musl-gcc"`

or prefix your `cargo build` command with it to just apply it to that build:

`$CC_x86_64_unknown_linux_musl="x86_64-linux-musl-gcc" cargo build --release --target x86_64-unknown-linux-musl`

## Running

As mentioned above, this tutorial uses [docker-lambda](https://github.com/lambci/docker-lambda), specifically the Go image, as it allows running Rust binaries natively.
In order to run our compiled program, we would do as follows:

```$ docker run --rm -v "$PWD":/var/task lambci/lambda:go1.x <path-to-executable> <input-to-handler-function>```

The `<input-to-handler-function>` argument is the content the handler function is expecting and can be anything. In this tutorial, we'll be using a JSON object, eg. `{"some": "event"}`.

### Reading from stdin

It's possible to pipe the `<input-to-handler-function>` from another command. In order to achieve that, the following command must be used:

`$ echo '{"some": "event"}' | docker run --rm -v "$PWD":/var/task -i -e DOCKER_LAMBDA_USE_STDIN=1 lambci/lambda:go1.x`

target/x86_64-unknown-linux-musl/release/rust-aws-lambda:
	CC_x86_64_unknown_linux_musl="x86_64-linux-musl-gcc" cargo build --release --target x86_64-unknown-linux-musl

clean:
	rm -f target/x86_64-unknown-linux-musl/release/rust-aws-lambda
	rm -rf output
	rm -f rust-aws-lambda.zip

run: target/x86_64-unknown-linux-musl/release/rust-aws-lambda
	cat examples/photo.json | docker run --rm -v $(PWD):/var/task -i -e DOCKER_LAMBDA_USE_STDIN=1 lambci/lambda:go1.x $< > output/output.json
	jq -r .body output/output.json > output/photo.base64
	base64 -D output/photo.base64 > output/thumbnail.png

aws: target/x86_64-unknown-linux-musl/release/rust-aws-lambda
	zip $< > output/rust-aws-lambda.zip

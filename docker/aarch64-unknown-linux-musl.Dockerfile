# -*- mode: dockerfile -*-
#
ARG BASE_IMAGE=messense/rust-musl-cross:aarch64-musl

# BUILDPLATFORM forces the build stage to be done on linux-amd64
# regardless of the specified target platform in the final stage.
FROM --platform=$BUILDPLATFORM ${BASE_IMAGE} AS builder

ADD --chown=rust:rust . ./

RUN cargo build --release

FROM alpine:latest
RUN apk --no-cache add ca-certificates

ARG FILE_TO_COPY=do_ddns
ENV FILE_TO_RUN="${FILE_TO_COPY}"
COPY --from=builder \
    /home/rust/src/target/aarch64-unknown-linux-musl/release/$FILE_TO_COPY \
    /usr/local/bin/

CMD "/usr/local/bin/${FILE_TO_RUN}"

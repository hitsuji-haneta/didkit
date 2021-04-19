FROM ekidd/rust-musl-builder as builder
# FROM rustlang/rust:nightly-alpine as builder
# FROM rustlang/rust:nightly-slim as builder


# RUN apk add --update --no-cache \
#     git \
#     openssl \
#     pkg-config

# RUN apt update && \
#     apt install -y git

# ADD --chown=rust:rust ./didkit /didkit
# ADD --chown=rust:rust ./ssi /ssi
ADD --chown=rust:rust ./didkit /didkit
ADD --chown=rust:rust ./ssi /ssi
WORKDIR /didkit/http

ENV CARGO_NET_GIT_FETCH_WITH_CLI=true

# USER root
# RUN --mount=type=cache,target=/usr/local/cargo/registry \
#     --mount=type=cache,target=/didkit/target \
#     cargo build --release
RUN cargo build --release

FROM alpine
COPY --from=builder /didkit/target/x86_64-unknown-linux-musl/release/didkit-http /usr/local/bin/
# COPY --from=builder /didkit/target/x86_64-unknown-linux-musl/debug/didkit-http /usr/local/bin/

ENTRYPOINT ["didkit-http"]

ARG HARDENED_MALLOC_VERSION=2024060400

### Build Hardened Malloc
FROM alpine:latest as hmalloc-builder

ARG HARDENED_MALLOC_VERSION
ARG CONFIG_NATIVE=false
ARG VARIANT=default

RUN apk -U upgrade \
    && apk --no-cache add build-base git gnupg openssh-keygen
    
RUN cd /tmp \
    && git clone --depth 1 --branch ${HARDENED_MALLOC_VERSION} https://github.com/GrapheneOS/hardened_malloc \
    && cd hardened_malloc \
    && wget -q https://grapheneos.org/allowed_signers -O grapheneos_allowed_signers \
    && git config gpg.ssh.allowedSignersFile grapheneos_allowed_signers \
    && git verify-tag $(git describe --tags) \
    && make CONFIG_NATIVE=${CONFIG_NATIVE} VARIANT=${VARIANT}

### Build Production

FROM node:alpine

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG UID=992
ARG GID=992

RUN apk -U upgrade \
    && apk --no-cache add git \
    && adduser -g ${GID} -u ${UID} --disabled-password --gecos "" matrix-to

USER matrix-to

WORKDIR /home/matrix-to

RUN git clone https://github.com/matrix-org/matrix.to

COPY element.patch /home/matrix-to/matrix.to

WORKDIR /home/matrix-to/matrix.to

RUN git apply /home/matrix-to/matrix.to/element.patch \
    && rm -rf .git \
    && yarn \
    && yarn build

COPY --from=hmalloc-builder /tmp/hardened_malloc/out/libhardened_malloc.so /usr/local/lib/

ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

EXPOSE 5000

ENTRYPOINT ["yarn", "start"]

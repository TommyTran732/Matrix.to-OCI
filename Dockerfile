FROM node:alpine

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG UID=992
ARG GID=992

COPY --from=ghcr.io/polarix-containers/hardened_malloc:latest /install /usr/local/lib/
ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

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
    && rm -rf yarn.lock \
    && yarn \
    && yarn cache clean \
    && yarn build

ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"

EXPOSE 5000

ENTRYPOINT ["yarn", "start"]

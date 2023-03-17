FROM node:alpine

LABEL maintainer="Thien Tran contact@tommytran.io"

ARG UID=992
ARG GID=992

RUN apk -U upgrade \
  && apk --no-cache add git \
  && adduser -g ${GID} -u ${UID} --disabled-password --gecos "" matrix-to

RUN git clone https://github.com/matrix-org/matrix.to \
  && cd matrix.to \
  && yarn \
  && yarn build
  
USER matrix-to
  
EXPOSE 5000

ENTRYPOINT ["yarn", "start"]

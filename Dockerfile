FROM solinea/bird:1.5.0-r2-2

#ENV CONFDVER v0.11.0
ENV CONFDVER master

RUN set -ex \
  && export GOPATH=/go \
  && export GO15VENDOREXPERIMENT=1 \
  && export CONFDFILE="${CONFDVER}.zip" \
  && export CONFDURL="https://github.com/kelseyhightower/confd/archive" \
  && export SRCPATH="$GOPATH/src/github.com/kelseyhightower" \
  && export TESTREPO="http://dl-4.alpinelinux.org/alpine/edge/testing" \
  && echo "@testing ${TESTREPO}" >> /etc/apk/repositories \
  && apk add --no-cache --update --virtual .build-deps \
    bash \
    git \
    go \
    wget \
  \
  && mkdir -p "$GOPATH/src/" "$GOPATH/bin" && chmod -R 777 "$GOPATH" \
  && mkdir -p "$SRCPATH" \
  && wget "$CONFDURL/$CONFDFILE" \
  && unzip "$CONFDFILE" \
  && mv "confd-$CONFDVER" "$SRCPATH/confd" \
  \
  && cd "$SRCPATH/confd" \
  && mkdir -p bin \
  && go build -o /usr/bin/confd . \
  \
  && rm -rf "$GOPATH" /confd-master /master.zip \
  && apk del .build-deps

# test
RUN confd -version

COPY etc/confd.toml /etc/confd/
COPY etc/conf.d/bird.toml /etc/confd/conf.d/
COPY etc/templates/bird.conf.tmpl /etc/confd/templates/

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/confd"]

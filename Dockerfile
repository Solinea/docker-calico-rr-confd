FROM solinea/bird:1.5.0-r2-5

# should match tag, but remove 'v' prefix
ARG CONFDVER=0.12.0-alpha3

RUN set -exo pipefail \
  && export GOPATH=/go \
  && export GO15VENDOREXPERIMENT=1 \
  && export CONFDFILE="v${CONFDVER}.zip" \
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
  && go build -o /usr/bin/confd . \
  \
  && rm -rf "$GOPATH" \
  && apk del .build-deps

COPY etc/confd.toml /etc/confd/
COPY etc/conf.d/bird.toml /etc/confd/conf.d/
COPY etc/templates/bird.conf.tmpl /etc/confd/templates/

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/bin/confd"]

FROM elixir:1.8-alpine AS BOB_THE_BUILDER

ARG MIX_ENV=prod

ENV MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache \
    git

RUN mix local.rebar --force && \
    mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN mkdir -p /opt/app/built && \
    mix release --verbose && \
    cp _build/prod/rel/pdf_maker/releases/0.1.0/pdf_maker.tar.gz /opt/app/built

## Now, build the actual release image

FROM alpine:3.8

RUN apk add --no-cache qt5-qtwebkit qt5-qtbase bash openssl

RUN apk add \
    --repository http://dl-3.alpinelinux.org/alpine/edge/community/ \
    --allow-untrusted \
    --no-cache \
    wkhtmltopdf

RUN rm -f /var/cache/apk/*

RUN mkdir -p /opt/app/pdf_maker

WORKDIR /opt/app/pdf_maker

RUN WK_PATH=$(find / -name wkhtmltopdf) && \
    export PATH=$WK_PATH:$PATH

COPY --from=BOB_THE_BUILDER /opt/app/built/pdf_maker.tar.gz .

RUN tar zxf pdf_maker.tar.gz && \
    rm pdf_maker.tar.gz

EXPOSE 4000
ENV PORT=4000 \
  MIX_ENV=prod \
  REPLACE_OS_VARS=true \
  SHELL=/bin/sh

ENTRYPOINT ["/opt/app/pdf_maker/bin/pdf_maker"]
CMD ["foreground"]

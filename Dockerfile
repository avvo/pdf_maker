FROM elixir:1.8-alpine AS BOB_THE_BUILDER

ENV MIX_ENV=prod

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

FROM avvo/alpine:3.9-wkhtmltopdf-0.12.5

RUN apk add --no-cache bash

RUN mkdir -p /opt/app/pdf_maker

WORKDIR /opt/app/pdf_maker

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

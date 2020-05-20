FROM avvo/elixir:1.8.2-otp22 AS BOB_THE_BUILDER

ARG MIX_ENV=prod

ENV MIX_ENV=${MIX_ENV}

WORKDIR /opt/app

RUN mix local.rebar --force && \
    mix local.hex --force

COPY . .

RUN mix do deps.get, deps.compile, compile

RUN mkdir -p /opt/app/built && \
    mix release --verbose && \
    cp _build/prod/rel/pdf_maker/releases/0.1.0/pdf_maker.tar.gz /opt/app/built

## Now, build the actual release image

FROM avvo/elixir-release-ubuntu:18.04

RUN apt-get update && \
    apt-get install -y libxext6 libfontconfig1 libxrender1

COPY bin/wkhtmltopdf /usr/local/bin/

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

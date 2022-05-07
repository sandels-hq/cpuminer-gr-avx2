FROM --platform=amd64 ubuntu:20.04

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl ca-certificates \
  libcurl4 libjansson4 libnuma-dev kmod msr-tools \
  && apt-get clean

RUN mkdir /ghjk && cd /ghjk \
  && curl -Lsf -O https://github.com/WyvernTKC/cpuminer-gr-avx2/releases/download/1.2.4.1/cpuminer-gr-1.2.4.1-x86_64_linux.tar.gz \
  && tar -xvof cpuminer-gr-1.2.4.1-x86_64_linux.tar.gz \
  && cp cpuminer-gr-1.2.4.1-x86_64_linux/binaries/* /usr/local/bin \
  && rm -rf /ghjk

RUN mkdir /ghjk && cd /ghjk \
  && curl -Lsf -O https://github.com/tsl0922/ttyd/releases/download/1.6.3/ttyd.x86_64 \
  && chmod +x ttyd.x86_64 \
  && mv ttyd.x86_64 /usr/local/bin/ttyd

LABEL org.opencontainers.image.source = "https://github.com/sandels-hq/cpuminer-gr-avx2"

WORKDIR /app
COPY app .

ENTRYPOINT [ "/app/entrypoint.sh" ]
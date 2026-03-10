FROM debian:13-slim

LABEL maintainer="Satoshi Yamamoto"
LABEL description="Pandoc with LaTeX (TeX Live bookpub scheme) for Japanese"
LABEL version="2026-03-10"
LABEL homepage="https://www.shoeisha.co.jp"
LABEL repository="https://github.com/YamamotoAtShoeisha/docker_pandoc_luatexja"

RUN apt update && apt upgrade -y && apt install -y wget perl libfontconfig
RUN cd /tmp && wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar zxvf install-tl-unx.tar.gz; cd install-tl-20* && \
./install-tl --no-interaction --no-doc-install --no-src-install -scheme bookpub
ENV PATH="/usr/local/texlive/2026/bin/x86_64-linux:${PATH}"
RUN tlmgr update --self --all && \
tlmgr install collection-langjapanese unicode-math \
    lualatex-math booktabs mdwtools
RUN wget https://github.com/jgm/pandoc/releases/download/3.9/pandoc-3.9-1-amd64.deb -O pandoc.deb \
    && apt install -y ./pandoc.deb \
    && rm pandoc.deb
RUN apt install -y fonts-noto-cjk-extra
VOLUME [ "/data" ]
WORKDIR /data
ENTRYPOINT [ "pandoc" ]
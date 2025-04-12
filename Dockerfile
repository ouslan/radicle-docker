FROM ubuntu:22.04

RUN groupadd --system seed
RUN useradd --system --gid seed --create-home seed

RUN curl -O -L https://files.radicle.xyz/releases/latest/radicle-linux.tar.xz

RUN tar -xvJf ARCHIVE.tar.xz --strip-components=1 -C ~/.radicle/

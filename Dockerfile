FROM ubuntu:focal

SHELL ["/bin/bash", "-c"]
WORKDIR /app

RUN groupadd -g 999 appuser
RUN useradd -r -u 999 -g appuser appuser
RUN adduser appuser sudo
RUN chown appuser:appuser .
RUN chpasswd <<<"appuser:root"

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:unit193/encryption
RUN apt-get update && apt-get install -y \
  sudo \
  dialog \
  veracrypt

COPY . .

USER appuser
CMD [ "bash", "run.sh" ]

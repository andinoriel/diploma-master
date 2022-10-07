FROM ubuntu:focal

RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
RUN mkdir -p /app
RUN chown appuser:appuser /app

# RUN apt-get update && apt-get install -y \
#

WORKDIR /app
COPY . /app

USER appuser
CMD [ "bash", "run.sh" ]

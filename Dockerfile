FROM ubuntu:focal

WORKDIR /app

RUN groupadd -g 999 appuser && useradd -r -u 999 -g appuser appuser
RUN chown appuser:appuser /app

RUN apt-get update && apt-get install -y \
  dialog

COPY . .

USER appuser
CMD [ "bash", "run.sh" ]

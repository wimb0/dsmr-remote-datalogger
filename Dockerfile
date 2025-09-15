FROM python:3.13-alpine AS builder

RUN apk add --no-cache curl build-base libffi-dev rust cargo

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip install --no-cache-dir pyserial requests python-decouple dsmr-parser

FROM python:3.13-alpine

WORKDIR /app

RUN addgroup dsmr && \
    adduser -D -G dsmr dsmr && \
    addgroup dsmr dialout

COPY --from=builder /opt/venv /opt/venv

RUN curl -o dsmr_datalogger_api_client.py https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v5/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py
RUN chown dsmr:dsmr /app/dsmr_datalogger_api_client.py

USER dsmr

ENV PATH="/opt/venv/bin:$PATH"

ENV DSMRREADER_REMOTE_DATALOGGER_API_HOSTS="http://dsmr-reader-host"
ENV DSMRREADER_REMOTE_DATALOGGER_API_KEYS="JE_API_KEY"
ENV DSMRREADER_REMOTE_DATALOGGER_INPUT_METHOD="serial"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PORT="/dev/ttyUSB0"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BAUDRATE="115200"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BYTESIZE="8"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PARITY="N"

CMD ["python", "./dsmr_datalogger_api_client.py"]

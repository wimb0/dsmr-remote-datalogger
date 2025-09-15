FROM python:3.13-slim

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --system dsmr && useradd --system --gid dsmr dsmr \
    && usermod -a -G dialout dsmr

RUN pip install --no-cache-dir pyserial requests python-decouple dsmr-parser

RUN curl -o dsmr_datalogger_api_client.py https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v5/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py
RUN chown dsmr:dsmr /app/dsmr_datalogger_api_client.py

USER dsmr

ENV DSMRREADER_REMOTE_DATALOGGER_API_HOSTS="http://dsmr-reader-host"
ENV DSMRREADER_REMOTE_DATALOGGER_API_KEYS="JE_API_KEY"
ENV DSMRREADER_REMOTE_DATALOGGER_INPUT_METHOD="serial"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PORT="/dev/ttyUSB0"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BAUDRATE="115200"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BYTESIZE="8"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PARITY="N"

CMD ["python", "./dsmr_datalogger_api_client.py"]

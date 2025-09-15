FROM python:3.13-alpine

WORKDIR /app

RUN apk add --no-cache curl build-base libffi-dev

RUN addgroup dsmr && \
    adduser -D -G dsmr dsmr && \
    addgroup dsmr dialout

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

#ENV DSMRREADER_REMOTE_DATALOGGER_TIMEOUT=""
#ENV DSMRREADER_REMOTE_DATALOGGER_SLEEP=""
#ENV DSMRREADER_REMOTE_DATALOGGER_DEBUG_LOGGING="true"

CMD ["python", "./dsmr_datalogger_api_client.py"]

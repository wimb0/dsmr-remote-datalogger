FROM python:3.15-alpine

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

RUN pip install pyserial requests python-decouple

# Non-root gebruiker met toegang tot de seriële poort
RUN addgroup -S dsmr \
 && adduser -S -G dsmr dsmr \
 && addgroup dsmr dialout

ADD --chown=dsmr:dsmr --chmod=644 \
    https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v6/src/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py \
    /app/dsmr_datalogger_api_client.py

USER dsmr

ENV DSMRREADER_REMOTE_DATALOGGER_API_HOSTS="http://dsmr-reader-host" \
    DSMRREADER_REMOTE_DATALOGGER_INPUT_METHOD="serial" \
    DSMRREADER_REMOTE_DATALOGGER_SERIAL_PORT="/dev/ttyUSB0" \
    DSMRREADER_REMOTE_DATALOGGER_SERIAL_BAUDRATE="115200" \
    DSMRREADER_REMOTE_DATALOGGER_SERIAL_BYTESIZE="8" \
    DSMRREADER_REMOTE_DATALOGGER_SERIAL_PARITY="N"
# DSMRREADER_REMOTE_DATALOGGER_API_KEYS="JE_API_KEY"

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD ["pgrep", "-f", "dsmr_datalogger_api_client.py"]

CMD ["python", "/app/dsmr_datalogger_api_client.py"]

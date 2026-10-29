FROM python:3.15-alpine

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

# Non-root gebruiker met toegang tot de seriële poort
RUN addgroup -S dsmr \
 && adduser -S -G dsmr dsmr \
 && addgroup dsmr dialout

# Pin bij voorkeur op een commit-hash i.p.v. de v6-branch
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
# DSMRREADER_REMOTE_DATALOGGER_API_KEYS: bij runtime meegeven

CMD ["python", "/app/dsmr_datalogger_api_client.py"]

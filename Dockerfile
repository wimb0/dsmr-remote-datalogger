# Gebruik een compacte Python 3.13 Alpine image als basis
FROM python:3.13-alpine

# Stel de werkdirectory in de container in
WORKDIR /app

# Maak een non-root user aan met de naam 'dsmr' en voeg deze toe aan de 'dialout' groep
# Dit is nodig om toegang te krijgen tot de seriële (USB) poort.
RUN addgroup dsmr && \
    adduser -D -G dsmr dsmr && \
    addgroup dsmr dialout

# Installeer de benodigde Python packages.
# dsmr-parser is essentieel voor het parsen van de P1-telegrammen.
RUN pip install --no-cache-dir pyserial requests python-decouple dsmr-parser

# Download het DSMR datalogger script van GitHub
RUN curl -o dsmr_datalogger_api_client.py https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v5/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py

# Verander de eigenaar van de bestanden naar de 'dsmr' user
RUN chown dsmr:dsmr /app/dsmr_datalogger_api_client.py

# Schakel over naar de non-root user
USER dsmr

# Stel de omgevingsvariabelen in met de juiste namen.
# Deze kun je overschrijven bij het starten van de container.
ENV DSMRREADER_REMOTE_DATALOGGER_API_HOSTS="http://dsmr-reader-host"
ENV DSMRREADER_REMOTE_DATALOGGER_API_KEYS="JE_API_KEY"
ENV DSMRREADER_REMOTE_DATALOGGER_INPUT_METHOD="serial"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PORT="/dev/ttyUSB0"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BAUDRATE="115200"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BYTESIZE="8"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PARITY="N"

# Start het script wanneer de container wordt opgestart
CMD ["python", "./dsmr_datalogger_api_client.py"]

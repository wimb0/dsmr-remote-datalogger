# Gebruik een compacte Python 3.13 Alpine image als basis
FROM python:3.13-alpine

# Stel de werkdirectory in de container in
WORKDIR /app

# --- NIEUWE REGEL ---
# Installeer curl, het programma om bestanden te downloaden.
# --no-cache zorgt ervoor dat de image klein blijft.
RUN apk add --no-cache curl

# Maak een non-root user aan met de naam 'dsmr' en voeg deze toe aan de 'dialout' groep
RUN addgroup dsmr && \
    adduser -D -G dsmr dsmr && \
    addgroup dsmr dialout

# Installeer de benodigde Python packages
RUN pip install --no-cache-dir pyserial requests python-decouple dsmr-parser

# Download het DSMR datalogger script van GitHub met het zojuist geïnstalleerde curl
RUN curl -o dsmr_datalogger_api_client.py https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v5/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py

# Verander de eigenaar van de bestanden naar de 'dsmr' user
RUN chown dsmr:dsmr /app/dsmr_datalogger_api_client.py

# Schakel over naar de non-root user
USER dsmr

# Stel de omgevingsvariabelen in met de juiste namen.
ENV DSMRREADER_REMOTE_DATALOGGER_API_HOSTS="http://dsmr-reader-host"
ENV DSMRREADER_REMOTE_DATALOGGER_API_KEYS="JE_API_KEY"
ENV DSMRREADER_REMOTE_DATALOGGER_INPUT_METHOD="serial"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PORT="/dev/ttyUSB0"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BAUDRATE="115200"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_BYTESIZE="8"
ENV DSMRREADER_REMOTE_DATALOGGER_SERIAL_PARITY="N"

# Start het script wanneer de container wordt opgestart
CMD ["python", "./dsmr_datalogger_api_client.py"]

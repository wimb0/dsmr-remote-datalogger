# Small Docker container for the DSMR Reader Remote Datalogger

[![CI - Build and Push Multi-Arch Docker Image](https://github.com/wimb0/dsmr-remote-datalogger/actions/workflows/ci.yaml/badge.svg)](https://github.com/wimb0/dsmr-remote-datalogger/actions/workflows/ci.yaml)

A compact, multi-platform Docker container for the DSMR Reader remote datalogger, using the official [dsmr_datalogger_api_client.py](https://raw.githubusercontent.com/dsmrreader/dsmr-reader/v5/dsmr_datalogger/scripts/dsmr_datalogger_api_client.py)

This container reads data from a smart meter via a P1 serial cable and forwards it to a receiving DSMR-reader instance.

All configuration is handled via environment variables as described in the [official DSMR Reader documentation](https://dsmr-reader.readthedocs.io/en/v5/how-to/installation/remote-datalogger.html#remote-datalogger-device).


## Usage (docker-compose)

1.  Create a `docker-compose.yaml` file.
2.  Update the `environment` variables with your details.
3.  Run `docker-compose up -d`.

```yaml
services:
  dsmr-datalogger:
    image: ghcr.io/wimb0/dsmr-remote-datalogger:latest
    container_name: dsmr-datalogger
    restart: unless-stopped
    devices:
      - "/dev/ttyUSB0:/dev/ttyUSB0"
    environment:
      # --- REQUIRED ---
      - DSMRREADER_REMOTE_DATALOGGER_API_HOSTS=http://YOUR_DSMR_READER_IP
      - DSMRREADER_REMOTE_DATALOGGER_API_KEYS=YOUR_API_KEY
```

## More info
For more info see [DSMR Reader (Github)](https://github.com/dsmrreader/dsmr-reader)

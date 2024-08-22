# Freiheit Katalog

## Intro

This container queries available xray-servers to get their corresponding vless config URLs and serves all of them together in a single config file.

## Usage

```yaml
xray-ws:
  image: ghcr.io/mehdi-behrooz/freiheit-xray:latest
  environment:
    - PROTOCOL=ws
    - LOG_LEVEL=debug
    - ...

xray-reality:
  image: ghcr.io/mehdi-behrooz/freiheit-xray:latest
  environment:
    - PROTOCOL=reality
    - LOG_LEVEL=debug
    - ...

katalog:
  image: ghcr.io/mehdi-behrooz/freiheit-katalog:latest
  depends_on: # optional
    xray-ws:
      condition: service_healthy
      restart: true
    xray-reality:
      condition: service_healthy
      restart: true
  ports:
    - "80:80"
  environment:
    - LOG_LEVEL=debug
    - ENCODE_CONFIG=true
    - CONFIG_PATH=/path/to/myconfig
    - LABEL=MyConfigs
    - XRAY_SERVERS=xray-ws, xray-reality
```

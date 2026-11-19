# Aurora Solarmeter - Home Assistant App

The Solarmeter daemon reads energy production from the ABB Aurora inverter via RS485 and publishes the data to a MQTT broker. Built upon the [libabbaurora](https://ahpohl.github.io/libabbaurora/) library.

> [!IMPORTANT]
> **HA 2026.11+**: This app uses the new `config.yaml` format (formerly known as "add-ons", now called "apps").
> It must be installed via the **App store** (Settings → Apps → Install app), not the Marketplace (HACS).
> The Marketplace only handles integrations, themes, and dashboards — not apps.

## Features

- Reads energy production from ABB Aurora inverter via RS485
- Publishes JSON data to MQTT broker
- Configurable MQTT broker, topic, and authentication
- Supports TLS connections
- Configurable payment per kWh for financial tracking
- Runs on Raspberry Pi, Odroid, or any SBC with RS485 adapter

## Requirements

- Home Assistant Operating System (HAOS) — apps are only available on HAOS
- ABB Aurora inverter with RS485 communication port
- RS485-to-USB adapter (e.g., Waveshare USB-to-RS485)
- MQTT broker (built-in Mosquitto or external)

## Installation

### Recommended: App store (HAOS)

1. Go to **Settings → Apps → Install app**
2. Click **⋮ → Repositories → Add**
3. Paste: `https://github.com/jekkos/solarmeter`
4. Click **Add**
5. Find **Aurora Solarmeter** and click **Install**

> [!NOTE]
> The first install triggers a GitHub Actions build (~3-5 min) to produce the Docker image.
> If the app doesn't appear after adding the repository, wait for the build to complete, then refresh your browser.

### Not supported: Marketplace (HACS)

The Marketplace (built-in HACS) only handles **integrations**, **themes**, and **dashboards**.
Apps (formerly add-ons) are a separate category managed by the HAOS Supervisor.
Do not add this repository to the Marketplace — it will report "no content to install".

## Configuration

After installation, go to the app settings:

| Option | Description | Default |
|--------|-------------|---------|
| `log_level` | Comma-separated log levels (config, json, mosquitto, serial) | `config,json` |
| `serial_device` | RS485 adapter device path | `/dev/ttyUSB0` |
| `mqtt_broker` | MQTT broker hostname | `core-mosquitto` |
| `mqtt_port` | MQTT broker port | `1883` |
| `mqtt_topic` | MQTT topic for publishing data | `solarmeter` |
| `mqtt_user` | MQTT username (leave empty for anonymous) | |
| `mqtt_password` | MQTT password (leave empty for anonymous) | |
| `mqtt_tls_cafile` | TLS CA certificate file path (optional) | |
| `mqtt_tls_capath` | TLS CA certificate directory path (optional) | |
| `payment_kwh` | Payment per kWh for financial tracking | `0.0` |
| `max_read_iterations` | Maximum read iterations per cycle | `2000` |
| `character_read_delay_us` | RS485 character read delay in microseconds | `60` |

## MQTT Data Format

The app publishes JSON data to the configured MQTT topic with energy production data from the inverter.

## Updating

1. Go to **Settings → Apps**
2. Click on **Aurora Solarmeter**
3. Click **Update** in the top-right corner

The app auto-updates when a new version is published. To enable auto-update, turn on the **Auto update** toggle on the app's Info tab.

## Troubleshooting

### "Cannot connect to MQTT broker"
- Enable built-in Mosquitto: **Settings → System → Services → Mosquitto**
- Or configure external MQTT in the app settings

### Serial device not found
- Verify the RS485 adapter is connected to `/dev/ttyUSB0` (or configured path)
- Check that the adapter is recognized: **Settings → System → Hardware**

### No data from inverter
- Verify RS485 wiring (A/B lines)
- Check inverter RS485 port configuration
- Look at app logs for detailed errors

### Repository not showing up in App store
- Refresh your browser after adding the repository
- Ensure the repository contains apps (not integrations or themes)
- Check the **Supervisor** log: **Settings → System → Logs → Supervisor**
- Wait for the GitHub Actions build to complete (first install)

### GitHub Actions build failed
Common causes and fixes:
- **Platform name**: Use `linux/arm/v7` (not `linux/armv7`)
- **Base image**: Use `gcc:12-bookworm` or newer (not older Alpine)
- **Image tag**: Ensure the `image:` field in `config.yaml` matches your ghcr.io path
- **GitHub token**: The workflow uses `secrets.GITHUB_TOKEN` — no extra setup needed

## App Format (HA 2026.11+)

Home Assistant 2026.11+ renamed "add-ons" to "apps" and migrated to a new configuration format:

| Old format (config.json) | New format (config.yaml) |
|--------------------------|--------------------------|
| `"network_mode": "host"` | `host_network: true` |
| `boot: auto` | `homeassistant: 2024.1.0` |
| No `image:` field | `image: ghcr.io/...` (required) |
| JSON syntax | YAML syntax |

This app uses the new `config.yaml` format. See the [official HA docs](https://www.home-assistant.io/common-tasks/os/apps/) for more details.

## Docker Run (standalone)

```bash
docker run -d \
  --name solarmeter \
  --network host \
  --device /dev/ttyUSB0 \
  -v $(pwd)/config.conf:/etc/solarmeter.conf:ro \
  ghcr.io/jekkos/solarmeter:latest
```

## Original Project

This is a repackaged version of the original [solarmeter](https://github.com/ahpohl/solarmeter) project for Home Assistant integration.

## License

MIT - see [LICENSE](LICENSE) file for details

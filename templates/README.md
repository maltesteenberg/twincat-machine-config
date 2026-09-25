# Inject templates

`machine.json.tpl` uses 1Password `op inject` placeholders:

```text
{{ op://Vault/Item/field }}
```

## Fictional examples

The names committed in this template are **not real**:

| Placeholder | Example value | Meaning |
|-------------|---------------|---------|
| Vault | `Example-Vault` | Fictional 1Password vault |
| Item | `example-machine` | Fictional machine item |
| Fields | `machine-name`, `modbus-ip`, `ams-netid` | Fictional field names |

Rename them to match your vault before running `scripts/inject-config.ps1`. Do not commit the real vault, item, or field names if this repo (or a fork) will be public.

`config/machine.example.json` shows the same shape with obviously fake endpoints only: Modbus IP `0.0.0.0`, AMS NetId `0.0.0.0.1.1`.

Never commit the injected output (`C:\MachineConfig\machine.json`).

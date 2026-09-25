# Inject templates

`machine.json.tpl` uses 1Password `op inject` placeholders:

```text
{{ op://Vault/Item/field }}
```

The vault (`TwinCAT-Machines`), item (`line-01`), and field names (`machine-name`, `modbus-ip`, `ams-netid`) are **examples**. Rename them to match your vault before running `scripts/inject-config.ps1`.

Never commit the injected output (`C:\MachineConfig\machine.json`).

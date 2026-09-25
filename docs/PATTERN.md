# Pattern: 1Password → MachineConfig → TwinCAT

## Three layers only

```
┌─────────────────────────┐
│ 1. 1Password vault      │  real Modbus IP / AMS NetId / passwords
│    (op://Vault/Item/…)  │  never in git
└───────────┬─────────────┘
            │  op inject  (scripts/inject-config.ps1)
            ▼
┌─────────────────────────┐
│ 2. C:\MachineConfig\    │  machine-local JSON on the Windows IPC
│    machine.json         │  OUTSIDE TwinCAT project / git repo
└───────────┬─────────────┘
            │  FB_LoadMachineConfig at PLC startup
            ▼
┌─────────────────────────┐
│ 3. TwinCAT ST           │  STRING/struct in GVL_MachineConfig
│    then Modbus / routes │  no hardcoded production IPs in source
└─────────────────────────┘
```

## Why the PLC cannot read 1Password directly

- TwinCAT runtime on the IPC has no sanctioned `op` client and must not hold vault tokens.
- Commissioning injects once (or on deploy); the PLC only reads a local file path.
- Separating vault → disk → PLC keeps secrets out of source control and agent context.

## Agent ignore files

| Tool   | Mechanism |
|--------|-----------|
| Git    | `.gitignore` — blocks commit of secrets |
| Cursor | `.cursorignore` — blocks indexing/read of secret paths |
| Codex  | **No `.codexignore`**. Use `.codex/config.toml` permission deny rules under `:workspace_roots` |

## Commissioning flow

1. Create vault items per machine (Modbus IP, AMS NetId, machine name, …).
2. Copy/adapt `templates/machine.json.tpl` `op://` references to your vault/item/field names.
3. On the IPC (as a human or deploy script): `.\scripts\inject-config.ps1`
4. Confirm `C:\MachineConfig\machine.json` exists; do not commit it.
5. PLC calls `FB_LoadMachineConfig` at startup; on fault, do not connect.
6. Open Modbus / TwinCAT routes only when `GVL_MachineConfig.bConfigOk`.

## Checklist

See [CHECKLIST.md](CHECKLIST.md).

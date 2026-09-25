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

## Example names in this repo

Committed references are fictional: vault `Example-Vault`, item `example-machine`. Example endpoints are `0.0.0.0` and `0.0.0.0.1.1`. Rename vault/item/field names on the machine to match 1Password. Do not commit the real names.

## Agent ignore files

| Tool   | Mechanism |
|--------|-----------|
| Git    | `.gitignore` — blocks commit of `.env` (keeps fictional `.env.example`), injected `machine.json` / `modbus.json`, `StaticRoutes.xml`, a copied `MachineConfig/` directory, and key/credential files |
| Cursor | `.cursorignore` — blocks indexing/read of those secret paths; `.env.example` stays visible |
| Codex  | **No `.codexignore`**. `.codex/config.toml` denies the same paths under `:workspace_roots`, and denies absolute `C:\MachineConfig` and `/etc/MachineConfig` |

Git cannot ignore `C:\MachineConfig` while it lives only on the IPC, outside the worktree. See [SECURITY.md](../SECURITY.md).

## Commissioning flow

1. Create vault items per machine (Modbus IP, AMS NetId, machine name, …).
2. Copy/adapt `templates/machine.json.tpl` `op://` references. The committed vault and item (`Example-Vault` / `example-machine`) are fictional; point them at your vault only in the private machine setup.
3. On the IPC (as a human or deploy script): `.\scripts\inject-config.ps1`
4. Confirm `C:\MachineConfig\machine.json` exists; do not commit it.
5. PLC calls `FB_LoadMachineConfig` at startup; on fault, do not connect.
6. Open Modbus / TwinCAT routes only when `GVL_MachineConfig.bConfigOk`.

## Checklist

See [CHECKLIST.md](CHECKLIST.md).

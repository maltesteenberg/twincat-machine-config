# twincat-machine-config

Agent-ready TwinCAT machine config template. Secrets stay in 1Password; `op inject` writes machine-local files under `C:\MachineConfig\` on the Windows IPC; the PLC loads that JSON at startup into STRING/struct variables. No live Modbus IPs or AMS NetIds belong in source.

## Flow

```
1Password vault (op://…)
        │  op inject
        ▼
C:\MachineConfig\machine.json   ← outside TwinCAT project / git
        │  FB_LoadMachineConfig
        ▼
GVL_MachineConfig → Modbus / AMS routes
```

## Quick start

**Option A — copy into a TwinCAT project**

1. Copy `plc/`, `templates/`, and `scripts/` into your PLC solution (or a sidecar folder next to it).
2. Adapt `templates/machine.json.tpl` vault/item/field names.
3. On the IPC: `.\scripts\inject-config.ps1`
4. Implement `FB_LoadMachineConfig` parse steps; call it once at startup.

**Option B — sidecar repo**

Keep this repo beside the TwinCAT project. Inject on the IPC; reference the ST skeletons from the PLC project. Never symlink `C:\MachineConfig` into git.

## Where secrets live

| Location | Contents |
|----------|----------|
| 1Password | Real IPs, NetIds, passwords |
| `C:\MachineConfig\` | Injected JSON on the IPC only |
| This repo | Placeholders, `op://` templates, ST skeletons |

## Agent rules

See **[AGENTS.md](AGENTS.md)** (hard rules) and **[docs/PATTERN.md](docs/PATTERN.md)** (why three layers). Commissioning steps: **[docs/CHECKLIST.md](docs/CHECKLIST.md)**.

## Requirements

- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (`op`) on the IPC
- TwinCAT 3
- Windows IPC (typical); `scripts/inject-config.sh` is optional for Linux/BSD targets later

## License

MIT — Copyright (c) 2026 Malte Steenberg

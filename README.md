# twincat-machine-config

Agent-ready TwinCAT machine config template. Secrets stay in 1Password; `op inject` writes machine-local files under `C:\MachineConfig\` on the Windows IPC; the PLC loads that JSON at startup into STRING/struct variables. No live Modbus IPs or AMS NetIds belong in source.

Committed examples are **fictional**: 1Password vault `Example-Vault`, item `example-machine`, Modbus IP `0.0.0.0`, AMS NetId `0.0.0.0.1.1`. Rename them only in a private machine setup. Do not publish real vault names or plant addresses.

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
2. Adapt `templates/machine.json.tpl` vault/item/field names (committed values `Example-Vault` / `example-machine` are fictional).
3. On the IPC: `.\scripts\inject-config.ps1`
4. Implement `FB_LoadMachineConfig` parse steps; call it once at startup.

**Option B — sidecar repo**

Keep this repo beside the TwinCAT project. Inject on the IPC; reference the ST skeletons from the PLC project. Never symlink `C:\MachineConfig` into git.

## Where secrets live

| Location | Contents |
|----------|----------|
| 1Password | Real IPs, NetIds, passwords |
| `C:\MachineConfig\` | Injected JSON on the IPC only |
| This repo | Fictional placeholders, `op://` templates, ST skeletons |

Ignore and deny rules (details in [AGENTS.md](AGENTS.md) and [SECURITY.md](SECURITY.md)):

| Tool | File | Blocks |
|------|------|--------|
| Git | `.gitignore` | `.env` (except `.env.example`), `machine.json`, `modbus.json`, `StaticRoutes.xml`, `MachineConfig/` inside a tree, keys and credential files |
| Cursor | `.cursorignore` | Same secret paths, so agents do not index them. `.env.example` stays visible. |
| Codex | `.codex/config.toml` | Same paths under the workspace, plus absolute `C:\MachineConfig` and `/etc/MachineConfig` |

Git cannot ignore `C:\MachineConfig` on the IPC because that directory is outside the repo. Do not copy it into the project.

## Agent rules

See **[AGENTS.md](AGENTS.md)** (hard rules) and **[docs/PATTERN.md](docs/PATTERN.md)** (why three layers). Commissioning steps: **[docs/CHECKLIST.md](docs/CHECKLIST.md)**. Disclosure policy: **[SECURITY.md](SECURITY.md)**.

## Before going public / before publishing

Do this before flipping the GitHub repository from private to public. Visibility is a human step; it is not performed by the template scripts.

- [ ] Grep the tree and full git history for real IPs and AMS NetIds (expect only `0.0.0.0` and `0.0.0.0.1.1`)
- [ ] Revoke any leftover tokens (1Password service accounts, `op` sessions, personal access tokens) that were ever used with this repo
- [ ] Confirm no MachineConfig dumps (`machine.json`, `modbus.json`, `StaticRoutes.xml`, or a copied `C:\MachineConfig` tree) in the worktree or in history

Commands and the rest of the list: [docs/CHECKLIST.md](docs/CHECKLIST.md).

## Requirements

- [1Password CLI](https://developer.1password.com/docs/cli/get-started/) (`op`) on the IPC
- TwinCAT 3
- Windows IPC (typical); `scripts/inject-config.sh` is optional for Linux/BSD targets later

## License

MIT — Copyright (c) 2026 Malte Steenberg

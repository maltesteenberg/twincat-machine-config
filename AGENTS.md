# Agent rules — twincat-machine-config

Hard constraints for coding agents (Cursor, Codex, Copilot, etc.).

## NEVER

- Invent or ask the user to paste **live** PLC / Modbus IPs, AMS NetIds, or passwords into chat or source.
- Commit `.env`, anything under `C:\MachineConfig`, injected JSON (`machine.json`, `modbus.json`), or `StaticRoutes.xml`.
- Hardcode a production IP / NetId as a “temporary fallback” in ST when config is missing.
- Read or echo contents of injected machine-local config files.

## ONLY edit

- Example / template files (`config/machine.example.json`, `templates/*.tpl`, `.env.example`)
- ST skeletons (`plc/*.st`)
- Docs, scripts, ignore files, and Codex permission config

## MUST implement

- `FB_LoadMachineConfig` reads from constant default path: `C:\MachineConfig\machine.json`
- On missing or invalid config: set fault (`bConfigFault` / `bError`), clear IPs, **do not connect** Modbus or open routes
- Point humans to `scripts/inject-config.ps1` for `op inject` — do not substitute by writing secrets into the repo

## Secrets tooling

| Agent  | Block mechanism |
|--------|-----------------|
| Git    | `.gitignore` |
| Cursor | `.cursorignore` |
| Codex  | `.codex/config.toml` permission denials (no `.codexignore`) |

Denied paths (all three tools, as far as each tool can see):

- `.env` and `.env.*` except the tracked fictional `.env.example`
- Injected `machine.json`, `modbus.json`, `*.local.json`
- `StaticRoutes.xml` (TwinCAT route dumps)
- A `MachineConfig/` directory copied into a repo
- Private keys and credential files (`*.pem`, `*.key`, `*.pfx`, `credentials.json`, `secrets.json`)

Codex also denies the absolute IPC paths `C:\MachineConfig` and `/etc/MachineConfig`. Git and Cursor only match paths inside the workspace, so never copy those directories into the repo. Policy write-up: [SECURITY.md](SECURITY.md).

## Before going public / before publishing

- [ ] Grep the tree and full git history for real IPs and AMS NetIds (expect only `0.0.0.0` and `0.0.0.0.1.1`)
- [ ] Revoke any leftover tokens (1Password service accounts, `op` sessions, personal access tokens)
- [ ] Confirm no MachineConfig dumps in the worktree or in git history

Full checklist: [docs/CHECKLIST.md](docs/CHECKLIST.md). Do not change GitHub visibility from an agent session.

## Human path for inject

```powershell
.\scripts\inject-config.ps1
# optional: -TemplatePath templates\machine.json.tpl -OutDir C:\MachineConfig -OutName machine.json
```

Vault/item/field names in templates are **fictional examples** (`Example-Vault` / `example-machine`). Rename them to match the real 1Password layout only on the machine. Do not commit real vault or item names.

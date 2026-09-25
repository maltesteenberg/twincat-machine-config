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

## Human path for inject

```powershell
.\scripts\inject-config.ps1
# optional: -TemplatePath templates\machine.json.tpl -OutDir C:\MachineConfig -OutName machine.json
```

Vault/item/field names in templates are **examples** — rename to match the real 1Password layout.

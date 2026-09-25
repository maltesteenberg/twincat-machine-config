# Security

This repository is a **template**. It ships with placeholders only:

- Fictional 1Password references: `op://Example-Vault/example-machine/...`
- Obviously fake endpoints: Modbus IP `0.0.0.0`, AMS NetId `0.0.0.0.1.1`

It does not contain a live plant, PLC address, vault token, or password. Real values belong in 1Password. On the IPC, inject them with `scripts/inject-config.ps1` into `C:\MachineConfig\` (outside git). See [AGENTS.md](AGENTS.md).

## Never commit

- `.env` and other local environment files (`.env.example` is the only env file that belongs in git, and it must stay fictional)
- Injected config: `machine.json`, `modbus.json`, `*.local.json`
- Anything under `C:\MachineConfig\` (Windows IPC) or `/etc/MachineConfig/` (optional Linux helper), including a copied `MachineConfig/` directory inside a repo
- `StaticRoutes.xml` and other TwinCAT route dumps
- Real Modbus/PLC IP addresses, AMS NetIds, or passwords
- 1Password service-account tokens, `op` session tokens, or personal access tokens
- Private keys, certificates, or credential JSON (`*.pem`, `*.key`, `*.pfx`, `credentials.json`, `secrets.json`)

Git ignore rules cover files inside the repo. They cannot block `C:\MachineConfig` on the IPC because that path is outside the worktree. Codex denies that absolute path in `.codex/config.toml`. Cursor ignores the same class of files via `.cursorignore`.

## Reporting a vulnerability

If you find a live secret, token, or plant address in this repository (including git history):

1. Do not open a public issue, pull request, or chat message that repeats the secret.
2. Use GitHub private vulnerability reporting (repository **Security** tab → **Report a vulnerability**) when it is enabled.
3. Otherwise contact the repository owner out of band. The copyright holder in [LICENSE](LICENSE) is Malte Steenberg. Do not send the secret itself to a public channel; describe where it appears and revoke or rotate it.

## Before publishing

Follow the "Before going public / before publishing" checklist in [docs/CHECKLIST.md](docs/CHECKLIST.md) before changing GitHub visibility.

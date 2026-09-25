# Implementation checklist

Copy into your TwinCAT project PR / commissioning ticket.

## Vault

- [ ] 1Password vault exists (fictional template name: `Example-Vault` — rename locally; do not commit the real vault name)
- [ ] Item per machine (fictional template item: `example-machine`) with fields: `machine-name`, `modbus-ip`, `ams-netid` (rename as needed)
- [ ] No live secrets pasted into chat, tickets, or source

## Templates & inject

- [ ] `templates/machine.json.tpl` `op://` paths match vault/item/field names
- [ ] `op` CLI installed and signed in on the IPC
- [ ] Ran `scripts/inject-config.ps1` (or `.sh` on Linux targets)
- [ ] `C:\MachineConfig\machine.json` present on IPC
- [ ] File is **not** under the TwinCAT project tree
- [ ] File is **not** staged/committed (covered by `.gitignore`)

## TwinCAT

- [ ] Copied `plc/GVL_MachineConfig.st` into the PLC project
- [ ] Implemented `FB_LoadMachineConfig` with file open/read + JSON parse (Tc3 JsonXml / file FBs)
- [ ] Default path constant remains `C:\MachineConfig\machine.json`
- [ ] Startup calls load FB before any Modbus connect / route use
- [ ] On missing/invalid config: `bConfigFault`, clear IPs, **do not connect**
- [ ] No production IP / NetId hardcoded as fallback in ST

## Agent safety

- [ ] `.gitignore` and `.cursorignore` present in the consuming repo
- [ ] Codex: ship or merge `.codex/config.toml` deny rules for secret paths
- [ ] Agents only edit example/template/ST skeleton files — never injected JSON

## Verify

- [ ] Grep source for real plant IPs / NetIds — the only addresses in tree should be the placeholders `0.0.0.0` and `0.0.0.0.1.1`
- [ ] Cold start with missing `machine.json` → fault, no connection attempt
- [ ] Cold start with valid inject → `bConfigOk`, Modbus/AMS use loaded values

## Before going public / before publishing

Run this before changing GitHub visibility. Do not flip the repo to public from an agent or script in this template.

- [ ] Grep the tree and **full git history** for real IPs and AMS NetIds. Expect only `0.0.0.0` and `0.0.0.0.1.1`. From the repo root:

  ```bash
  git grep -I -n -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' $(git rev-list --all)
  git log -p --all -S 'op://'
  ```

- [ ] Revoke any leftover tokens (1Password service-account tokens, `op` session tokens, personal access tokens) that were ever used with this repo, even if they never landed in a commit
- [ ] Confirm no MachineConfig dumps in the worktree or in history: `machine.json`, `modbus.json`, `StaticRoutes.xml`, and any copy of `C:\MachineConfig`
- [ ] Confirm tracked `op://` refs on the branch you will publish are the fictional `Example-Vault` / `example-machine` pair (see `.env.example` and `templates/machine.json.tpl`). Earlier commits in this template may still mention the previous fictional names `TwinCAT-Machines` and `line-01`. Those are examples, not a live vault. Any other vault name, token, or non-placeholder IP needs a history rewrite before publish.
- [ ] Read [SECURITY.md](../SECURITY.md) and enable GitHub secret scanning / push protection when the repository is public

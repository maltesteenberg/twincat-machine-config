# Implementation checklist

Copy into your TwinCAT project PR / commissioning ticket.

## Vault

- [ ] 1Password vault exists (example name: `TwinCAT-Machines`)
- [ ] Item per machine with fields: `machine-name`, `modbus-ip`, `ams-netid` (rename as needed)
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

- [ ] Grep source for real plant IPs / NetIds — expect **zero** hits
- [ ] Cold start with missing `machine.json` → fault, no connection attempt
- [ ] Cold start with valid inject → `bConfigOk`, Modbus/AMS use loaded values

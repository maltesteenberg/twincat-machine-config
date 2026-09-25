#Requires -Version 5.1
<#
.SYNOPSIS
  Inject 1Password secrets into a machine-local JSON config (outside the TwinCAT repo).

.DESCRIPTION
  Runs `op inject` against a template and writes the result under OutDir.
  Never prints secret values. Prefer this over pasting IPs into chat or source.

.PARAMETER TemplatePath
  Path to the op-inject template. Default: templates/machine.json.tpl

.PARAMETER OutDir
  Destination directory on the Windows IPC. Default: C:\MachineConfig

.PARAMETER OutName
  Output filename. Default: machine.json
#>
[CmdletBinding()]
param(
    [string]$TemplatePath = "templates/machine.json.tpl",
    [string]$OutDir = "C:\MachineConfig",
    [string]$OutName = "machine.json"
)

$ErrorActionPreference = "Stop"

function Assert-OpCli {
    $op = Get-Command op -ErrorAction SilentlyContinue
    if (-not $op) {
        Write-Error "1Password CLI 'op' not found on PATH. Install from https://developer.1password.com/docs/cli/get-started/"
        exit 1
    }
}

Assert-OpCli

if (-not (Test-Path -LiteralPath $TemplatePath)) {
    Write-Error "Template not found: $TemplatePath"
    exit 1
}

if (-not (Test-Path -LiteralPath $OutDir)) {
    New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
    Write-Host "Created directory: $OutDir"
}

$OutPath = Join-Path $OutDir $OutName

Write-Host "Injecting secrets from template into machine-local config..."
Write-Host "  Template: $TemplatePath"
Write-Host "  Output:   $OutPath"

& op inject -i $TemplatePath -o $OutPath
if ($LASTEXITCODE -ne 0) {
    Write-Error "op inject failed with exit code $LASTEXITCODE"
    exit $LASTEXITCODE
}

Write-Host "Success. Config written to: $OutPath"
Write-Host "(Secret values are not echoed.)"
exit 0

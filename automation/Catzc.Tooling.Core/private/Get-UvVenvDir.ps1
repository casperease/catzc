<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Get-UvVenvDir.ps1
    folder: private
    name: get-uv-venv-dir
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  config:
    synopsis: Returns the dedicated uv-venv directory for a tool installed via `uv_venv`.
    description: |-
      A `uv_venv` tool (e.g. the Azure CLI) lives in its own venv so the package's launcher finds an adjacent
      python. All such venvs sit under one user-space root — %LOCALAPPDATA%\catzc\venvs on Windows,
      ~/.local/share/catzc/venvs on Unix — one subdirectory per tool. The venv's script directory (Scripts on
      Windows, bin on Unix) is what goes on PATH.
    parameters:
      Tool: The snake_case tool key.
---
#>

function Get-UvVenvDir {
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $Tool
    )

    $root = if ($IsWindows) {
        Join-Path $env:LOCALAPPDATA 'catzc\venvs'
    }
    else {
        Join-Path $HOME '.local/share/catzc/venvs'
    }
    Join-Path $root $Tool
}

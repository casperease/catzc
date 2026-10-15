<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/private/Get-UvVenvDir.ps1
    kind: function
    module: Catzc.Tooling.Core
    visibility: private
---
#>

<#
.SYNOPSIS
    Returns the dedicated uv-venv directory for a tool installed via `uv_venv`.
.DESCRIPTION
    One subfolder per tool under a user-space root; its Scripts or bin folder, not the venv itself, goes on PATH.
    [comment:1](/docs/references/automation/catzc-tooling-core/private/Get-UvVenvDir.ps1.md#comment1)
.PARAMETER Tool
    The snake_case tool key.
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

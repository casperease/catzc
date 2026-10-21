<#
---
catzc:
  immutable:
    with_body_sha: be28de759672
  edges:
    docs: "[Get-UvVenvDir.ps1.md](docs/references/pwsh/catzc-tooling-core/private/Get-UvVenvDir.ps1.md)"
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

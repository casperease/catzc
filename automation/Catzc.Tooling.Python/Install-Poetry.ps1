<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Python/Install-Poetry.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Python
    visibility: public
  config:
    synopsis: Installs Poetry as an isolated uv tool.
    description: |-
      Installs Poetry user-space via uv (`uv tool install poetry`) in its own environment. Requires uv.
      Idempotent — skips if the correct version is already on PATH.
    parameters:
      Version: Poetry version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-Poetry
      - Install-Poetry -Version '2.0'
---
#>

function Install-Poetry {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'poetry').version,
        [switch] $Force
    )

    Install-UvTool -Tool 'poetry' -Version $Version -Force:$Force
}

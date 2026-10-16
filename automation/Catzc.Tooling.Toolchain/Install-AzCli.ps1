<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Install-AzCli.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    visibility: public
  config:
    synopsis: Installs the Azure CLI, user-space into a dedicated uv venv.
    description: |-
      Installs az into its own uv venv (`uv venv` + `uv pip install azure-cli`) on every platform — user-space,
      no admin. az's launcher runs the python beside it, so it needs a venv with its own interpreter rather than
      a uv-tool shim. Requires uv. Idempotent — skips if the correct version is already on PATH.
    parameters:
      Version: Azure CLI version to install. Defaults to the locked version in Get-ToolConfig.
      Force: Replace an existing installation at the wrong version.
    examples:
      - Install-AzCli
      - Install-AzCli -Version '2.74'
---
#>

function Install-AzCli {
    [CmdletBinding()]
    param(
        [string] $Version = (Get-ToolConfig -Tool 'az_cli').version,
        [switch] $Force
    )

    Install-UvVenvTool -Tool 'az_cli' -Version $Version -Force:$Force
}

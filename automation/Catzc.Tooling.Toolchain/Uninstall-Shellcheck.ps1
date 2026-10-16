<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
  config:
    synopsis: Uninstalls ShellCheck installed by Install-Shellcheck.
    description: Delegates to Uninstall-Tool, which removes the winget or brew package the tools.yml `shellcheck` entry names.
    parameters:
      Version: 'The installed version to remove. Default: whatever is installed.'
    examples:
      - Uninstall-Shellcheck
---
#>

function Uninstall-Shellcheck {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'shellcheck' -Version $Version
}

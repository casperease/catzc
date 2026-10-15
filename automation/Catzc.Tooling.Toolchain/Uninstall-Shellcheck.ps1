<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1
    kind: public-function
    module: Catzc.Tooling.Toolchain
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

<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1
    kind: function
    module: Catzc.Tooling.Toolchain
    visibility: public
---
#>

<#
.SYNOPSIS
    Uninstalls ShellCheck installed by Install-Shellcheck.
.DESCRIPTION
    Delegates to Uninstall-Tool, which removes the winget or brew package the tools.yml `shellcheck` entry names.
.PARAMETER Version
    The installed version to remove. Default: whatever is installed.
.EXAMPLE
    Uninstall-Shellcheck
#>
function Uninstall-Shellcheck {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'shellcheck' -Version $Version
}

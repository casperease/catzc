<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Shellcheck.ps1.md"
  header: "generated"
---
#>

function Uninstall-Shellcheck {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'shellcheck' -Version $Version
}

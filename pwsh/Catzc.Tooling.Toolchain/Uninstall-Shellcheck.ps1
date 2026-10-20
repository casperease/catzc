<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Uninstall-Shellcheck.ps1
    name: uninstall-shellcheck
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Tooling.Toolchain
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Uninstall-Shellcheck.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Shellcheck.ps1.md)"
---
#>

function Uninstall-Shellcheck {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'shellcheck' -Version $Version
}

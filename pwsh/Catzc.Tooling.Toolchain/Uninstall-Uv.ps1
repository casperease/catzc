<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Tooling.Toolchain/Uninstall-Uv.ps1
    name: uninstall-uv
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
    docs: "[Uninstall-Uv.ps1.md](docs/references/pwsh/catzc-tooling-toolchain/Uninstall-Uv.ps1.md)"
---
#>

function Uninstall-Uv {
    [CmdletBinding()]
    param(
        [string] $Version
    )

    Uninstall-Tool -Tool 'uv' -Version $Version
}

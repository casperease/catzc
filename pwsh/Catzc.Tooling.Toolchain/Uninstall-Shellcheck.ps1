<#
---
catzc:
  immutable:
    with_body_sha: "668427290508"
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

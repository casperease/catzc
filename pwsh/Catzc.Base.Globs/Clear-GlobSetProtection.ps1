<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Clear-GlobSetProtection.ps1.md"
  warning: "Generated Header"
---
#>

function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}

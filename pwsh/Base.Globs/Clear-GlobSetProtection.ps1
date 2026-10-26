<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Clear-GlobSetProtection.ps1.md"
  header: "generated"
---
#>

function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}

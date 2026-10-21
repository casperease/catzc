<#
---
catzc:
  immutable:
    with_body_sha: ed1b71af604d
  edges:
    docs: "[Clear-GlobSetProtection.ps1.md](../../docs/references/pwsh/catzc-base-globs/Clear-GlobSetProtection.ps1.md)"
    cites:
      - ADR-REPO-PROTGLOB
---
#>

function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}

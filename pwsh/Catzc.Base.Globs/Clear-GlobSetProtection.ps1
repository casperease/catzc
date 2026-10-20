<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Clear-GlobSetProtection.ps1
    name: clear-glob-set-protection
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    docs: "[Clear-GlobSetProtection.ps1.md](docs/references/pwsh/catzc-base-globs/Clear-GlobSetProtection.ps1.md)"
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

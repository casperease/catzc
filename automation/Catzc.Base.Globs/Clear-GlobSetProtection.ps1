<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Clear-GlobSetProtection.ps1
    name: clear-glob-set-protection
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    cites:
      - ADR-REPO-PROTGLOB
  config:
    synopsis: Drops every recorded glob protection, forcing the next run of every protected scan to scan in full.
    description: |-
      The escape hatch for the protected-glob skip
      ([ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)): the protection map is session memory, so
      an importer reload clears it anyway — this clears it without reloading. Use it when a full local rescan
      is wanted despite unchanged globsets (e.g. after changing the scan tool itself).
    examples:
      - Clear-GlobSetProtection
---
#>

function Clear-GlobSetProtection {
    [CmdletBinding()]
    param()

    $script:protectedGlobSets = @{}
    $script:pendingGlobProtections = @{}
}

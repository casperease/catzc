<#
---
catzc:
  immutable:
    with_body_sha: a0645a040acb
  edges:
    test: pwsh/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    docs: "[Get-TrackedFile.ps1.md](docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md)"
    cites:
      - ADR-AUTO-TRACKED-ONESEAM
      - FDR-CD-GLOBS-TRACKEDFILESONLY
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}

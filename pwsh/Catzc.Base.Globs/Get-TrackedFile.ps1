<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Globs/Get-TrackedFile.ps1
    name: get-tracked-file
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
    test: pwsh/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    docs: "[Get-TrackedFile.ps1.md](docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md)"
    cites:
      - ADR-AUTO-TRACKED-ONESEAM
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}

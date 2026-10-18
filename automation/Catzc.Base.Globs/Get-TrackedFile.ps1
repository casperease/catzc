<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    name: get-tracked-file
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
    test: automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    cites:
      - ADR-AUTO-TRACKED#1
      - ADR-FLOW-CD-GLOBS#4
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}

<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md"
  header: "generated"
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}

<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-globs/Get-TrackedFile.ps1.md"
  warning: "Generated Header"
---
#>

function Get-TrackedFile {
    param()
    Get-GitTrackedPath '.'
}

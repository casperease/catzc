<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/assets/test.ps1
    kind: asset
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

. ..\..\..\importer.ps1

Test-Command git

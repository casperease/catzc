<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.DevOps/assets/test.ps1
    kind: asset
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.DevOps
---
#>

. ..\..\..\importer.ps1

Test-Command git

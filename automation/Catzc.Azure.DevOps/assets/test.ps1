<#
---
catzc:
  immutable:
    path: automation/Catzc.Azure.DevOps/assets/test.ps1
    folder: assets
    name: test
    filetype: ps1
    kind: asset
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Azure.DevOps
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

. ..\..\..\importer.ps1

Test-Command git

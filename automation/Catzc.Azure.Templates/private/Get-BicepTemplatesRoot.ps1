<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/private/Get-BicepTemplatesRoot.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Azure.Templates
    visibility: private
  config:
    synopsis: Returns the root directory under which bicep templates are discovered.
    description: |-
      The single seam for *where* Get-BicepTemplates scans: $(Get-RepositoryRoot)/infrastructure/templates.
      Production has exactly one answer. Tests redirect discovery to a fixture tree by mocking this
      function (`Mock Get-BicepTemplatesRoot -ModuleName Catzc.Azure.Templates`), so unit tests never depend on
      the real, shipped templates under infrastructure/templates/. Get-BicepTemplates keys its session
      cache on this value, so a fixture root and the real root never collide.
    examples:
      - 'Get-BicepTemplatesRoot   # -> <repo>/infrastructure/templates'
---
#>

function Get-BicepTemplatesRoot {
    [OutputType([string])]
    param()

    Join-Path (Get-RepositoryRoot) 'infrastructure/templates'
}

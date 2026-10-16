<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
    kind: function
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Azure.Templates
    moduletype: pwsh-folder-module
    bundle: azure
    visibility: public
    relatives:
      test: automation/Catzc.Azure.Templates/tests/Get-AzureBicepEnvironmentKinds.Tests.ps1
    adrs:
      - ADR-AZ-DATAMOD
  config:
    synopsis: Returns the supported template environment kinds (which env class a template binds to).
    description: |-
      'standard'     (default) — the template's configs use standard environments (dev/test/preprod/prod),
                                 which may appear many-per-subscription.
      'subscription'           — the template's configs use per-subscription environments (nsub/psub),
                                 which appear exactly once per subscription. See
                                 [ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md).
    examples:
      - Get-AzureBicepEnvironmentKinds
---
#>

function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}

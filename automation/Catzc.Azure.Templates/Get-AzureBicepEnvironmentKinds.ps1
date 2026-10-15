<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Templates/Get-AzureBicepEnvironmentKinds.ps1
    kind: public-function
    module: Catzc.Azure.Templates
    visibility: public
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

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
---
#>

<#
.SYNOPSIS
    Returns the supported template environment kinds (which env class a template binds to).
.DESCRIPTION
    A subscription environment appears exactly once per subscription; a standard one may appear many times.
.EXAMPLE
    Get-AzureBicepEnvironmentKinds
#>
function Get-AzureBicepEnvironmentKinds {
    param()
    @('standard', 'subscription')
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Asserts/Assert-PsModule.ps1
    kind: function
    module: Catzc.Base.Asserts
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Asserts that a PowerShell module is available.
.PARAMETER Module
    The module name to look up via Get-Module -ListAvailable.
.PARAMETER ErrorText
    Optional message to throw instead of the default.
.EXAMPLE
    Assert-PsModule 'Pester'
#>
function Assert-PsModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string] $Module,

        [string] $ErrorText
    )

    if (-not (Get-Module $Module -ListAvailable)) {
        $message = if ($ErrorText) {
            $ErrorText
        }
        else {
            "Module '$Module' is not available"
        }
        throw $message
    }
}

# catzc:
#   path: automation/Catzc.Base.Asserts/Assert-PsModule.ps1
#   module: Catzc.Base.Asserts
#   visibility: public

<#
.SYNOPSIS
    Asserts that a PowerShell module is available.
.PARAMETER Module
    The module name to look up via Get-Module -ListAvailable.
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

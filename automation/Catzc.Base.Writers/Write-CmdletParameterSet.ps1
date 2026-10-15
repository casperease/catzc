<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Writers/Write-CmdletParameterSet.ps1
    kind: public-function
    module: Catzc.Base.Writers
    visibility: public
    adrs: []
---
#>

<#
.SYNOPSIS
    Writes all bound parameters of the calling function to the console.
.DESCRIPTION
    Only parameters the caller actually bound are listed, and -HiddenKeys masks the sensitive ones.
.PARAMETER Invocation
    The $MyInvocation from the calling function.
.PARAMETER HiddenKeys
    Parameter names whose values should be masked as 'Hidden'.
.PARAMETER ForegroundColor
    Color for the output. Defaults to Green.
.EXAMPLE
    function Deploy-App {
        param($Environment, $Token)
        Write-CmdletParameterSet $MyInvocation -HiddenKeys 'Token'
        # ...
    }
#>
function Write-CmdletParameterSet {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0)]
        [System.Management.Automation.InvocationInfo] $Invocation,

        [string[]] $HiddenKeys = @(),

        [Alias('Color')]
        [System.ConsoleColor] $ForegroundColor = 'Green'
    )

    $name = $Invocation.MyCommand.Name
    $header = "--- $name Parameters ---"
    Write-InformationColored $header -ForegroundColor $ForegroundColor

    foreach ($key in $Invocation.BoundParameters.Keys | Sort-Object) {
        $display = if ($key -in $HiddenKeys) {
            'Hidden'
        }
        else {
            $Invocation.BoundParameters[$key]
        }
        Write-InformationColored "$key = $display" -ForegroundColor $ForegroundColor
    }

    Write-InformationColored ('-' * $header.Length) -ForegroundColor $ForegroundColor
}

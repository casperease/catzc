<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-writers/Write-CmdletParameterSet.ps1.md"
  warning: "Generated Header"
---
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

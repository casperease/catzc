<#
---
catzc:
  immutable:
    with_body_sha: "8d5f273b474e"
  edges:
    test: pwsh/Catzc.Base.Writers/tests/Write-CmdletParameterSet.Tests.ps1
    docs: "[Write-CmdletParameterSet.ps1.md](docs/references/pwsh/catzc-base-writers/Write-CmdletParameterSet.ps1.md)"
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

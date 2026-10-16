<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Writers/Write-CmdletParameterSet.ps1
    name: write-cmdlet-parameter-set
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: automation/Catzc.Base.Writers/tests/Write-CmdletParameterSet.Tests.ps1
  config:
    synopsis: Writes all bound parameters of the calling function to the console.
    description: |-
      Pass $MyInvocation as the first argument at the top of a function to display
      all parameters that were actually bound. Sensitive parameters can be masked
      by listing their names in -HiddenKeys.
    parameters:
      Invocation: The $MyInvocation from the calling function.
      HiddenKeys: Parameter names whose values should be masked as 'Hidden'.
      ForegroundColor: Color for the output. Defaults to Green.
    examples:
      - |-
        function Deploy-App {
            param($Environment, $Token)
            Write-CmdletParameterSet $MyInvocation -HiddenKeys 'Token'
            # ...
        }
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

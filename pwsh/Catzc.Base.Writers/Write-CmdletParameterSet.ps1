<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Writers/Write-CmdletParameterSet.ps1
    name: write-cmdlet-parameter-set
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Writers
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
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

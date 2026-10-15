<#
---
catzc:
  derived:
    path: automation/Catzc.Azure.Cli/Test-AzCliExtension.ps1
    kind: gate-function
    module: Catzc.Azure.Cli
    visibility: public
  config:
    synopsis: Tests whether an Azure CLI extension is installed.
    description: |-
      Returns $true if the named extension is installed, $false otherwise. Uses `az extension show` (a core
      command) and inspects the exit code, so it never throws on a missing extension and never triggers a
      dynamic install. Companion to Assert-AzCliExtension, mirroring the Test-/Assert-AzCliConnected pair.
    parameters:
      Name: The extension name (e.g. 'ip-group').
    outputs: System.Boolean
    examples:
      - if (Test-AzCliExtension 'ip-group') { '...installed' }
---
#>

function Test-AzCliExtension {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$Name
    )

    # `extension show` is core; -NoAssert so a "not installed" non-zero exit is reported, not thrown.
    $cli = Invoke-AzCli "extension show --name $Name -o none" -PassThru -Silent -NoAssert
    return $cli.ExitCode -eq 0
}

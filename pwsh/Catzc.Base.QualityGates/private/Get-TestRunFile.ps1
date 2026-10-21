<#
---
catzc:
  immutable:
    with_body_sha: "672af24ca2b4"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
    docs: "[Get-TestRunFile.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-TestRunFile.ps1.md)"
---
#>

function Get-TestRunFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        $Test
    )

    if ($Test.PSObject.Properties['Block'] -and $Test.Block -and $Test.Block.PSObject.Properties['BlockContainer']) {
        $container = $Test.Block.BlockContainer
        if ($container -and $container.PSObject.Properties['Data']) {
            $data = $container.Data
            if ($data -is [System.Collections.IDictionary] -and $data.Contains('TestFolder')) {
                return [string]$data['TestFolder']
            }
        }
    }
    if ($Test.PSObject.Properties['ScriptBlock'] -and $Test.ScriptBlock) {
        return [string]$Test.ScriptBlock.File
    }
    ''
}

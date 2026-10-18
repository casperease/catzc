<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/.scriptanalyzer/Test-AnalyzedFileIsTest.ps1
    folder: automation/.scriptanalyzer
    name: test-analyzed-file-is-test
    filetype: ps1
    kind: analyzer-rule
    language: powershell
    track: automation
    tracktype: modules
---
#>

function Test-AnalyzedFileIsTest {
    [CmdletBinding()]
    [OutputType([bool])]
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.Language.ScriptBlockAst] $ScriptBlockAst,

        [switch] $IncludeTestsFolder
    )

    $file = "$($ScriptBlockAst.Extent.File)"
    if ($file) {
        if ($file.EndsWith('.Tests.ps1', [System.StringComparison]::OrdinalIgnoreCase)) {
            return $true
        }
        return [bool] ($IncludeTestsFolder -and $file -match '[\\/]tests[\\/]')
    }

    $root = $ScriptBlockAst
    while ($root.Parent) {
        $root = $root.Parent
    }
    $describe = $root.Find({
            param($node)
            $node -is [System.Management.Automation.Language.CommandAst] -and $node.GetCommandName() -eq 'Describe'
        }, $true)
    $null -ne $describe
}

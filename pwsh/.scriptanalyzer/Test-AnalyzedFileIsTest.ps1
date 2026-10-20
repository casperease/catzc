<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/.scriptanalyzer/Test-AnalyzedFileIsTest.ps1
    folder: pwsh/.scriptanalyzer
    name: test-analyzed-file-is-test
    filetype: ps1
    role: analyzer-rule
    language: powershell
    track: pwsh
    tracktype: modules
  edges:
    docs: "[Test-AnalyzedFileIsTest.ps1.md](docs/references/pwsh/scriptanalyzer/Test-AnalyzedFileIsTest.ps1.md)"
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

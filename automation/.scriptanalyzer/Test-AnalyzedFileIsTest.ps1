function Test-AnalyzedFileIsTest {
    <#
    .SYNOPSIS
        Whether the code under analysis is a Pester test file — the one scope test the custom checks share.
    .DESCRIPTION
        Several checks exempt test files, which change state, read raw variables, and use short names on purpose.
        [comment:1](/docs/references/automation/scriptanalyzer/Test-AnalyzedFileIsTest.ps1.md#comment1)
    .PARAMETER ScriptBlockAst
        Any block of the code under analysis; the whole buffer is searched from its root.
    .PARAMETER IncludeTestsFolder
        Also count a file under a tests/ folder (a fixture or helper beside the tests).
    .OUTPUTS
        [bool]
    #>
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

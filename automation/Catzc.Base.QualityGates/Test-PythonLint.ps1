<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-PythonLint.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-PY#8
---
#>

<#
.SYNOPSIS
    Quality gate: lints every Python file the repository holds with ruff.
.DESCRIPTION
    Covers the .py files no test run reads; the Python test bridge already runs the same check on a test folder.
    [ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md#comment1)
.PARAMETER OutputFolder
    The report base folder. Defaults to Write-QualityGateReport's (out/test-python-lint).
.PARAMETER PassThru
    Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on issues.
.OUTPUTS
    [pscustomobject] With -PassThru only.
.EXAMPLE
    Test-PythonLint
.EXAMPLE
    (Test-PythonLint -PassThru).Issues
#>
function Test-PythonLint {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $scope = @(Get-PythonCheckScope)
    $issues = [System.Collections.Generic.List[string]]::new()
    if ($scope.Count -gt 0) {
        # Exit 1 means findings and anything above it means ruff itself failed, so only 0 and 1 are results.
        # [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md#comment2)
        $check = Invoke-PythonWorkspaceTool -Tool 'ruff check --output-format concise' -File $scope
        if ($check.ExitCode -notin 0, 1) {
            throw "ruff could not check the Python files (exit $($check.ExitCode)):`n$($check.Full)"
        }
        # ruff names each file relative to the workspace root, where it ran; an issue names it repository-relative.
        $repositoryRoot = Get-RepositoryRoot
        $pythonRoot = Join-Path $repositoryRoot (Get-Config -Config python).ResolveRoot($repositoryRoot)
        foreach ($line in ($check.Output -split '\r?\n')) {
            if ($line -match '^(?<file>.+?):(?<rest>\d+:\d+: .+)$') {
                $full = [System.IO.Path]::GetFullPath($Matches['file'], $pythonRoot)
                $file = [System.IO.Path]::GetRelativePath($repositoryRoot, $full).Replace('\', '/')
                $issues.Add("${file}:$($Matches['rest'])")
            }
        }
    }

    Write-QualityGateReport -Subject python-lint -Title Test-PythonLint -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $scope.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}

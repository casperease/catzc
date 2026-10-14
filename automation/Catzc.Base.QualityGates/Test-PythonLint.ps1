<#
.SYNOPSIS
    Quality gate: lints every Python file the repository holds with ruff.
.DESCRIPTION
    Runs `ruff check` over every .py file the repository holds (Get-PythonCheckScope: the Python test folders, and the
    tracked .py files outside the Python root, such as the agent helpers under .claude/;
    [ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)), with the pinned ruff and
    the Python test workspace's settings (Invoke-PythonWorkspaceTool). Every finding is one issue, as ruff reports it:
    '<file>:<line>:<column>: <code> <message>'. The Python test bridge runs the same check on a test folder before its
    tests; this gate covers the files no test run reads.

    Ends with Write-QualityGateReport: the report lands in out/test-python-lint/, and the gate throws once listing every
    issue (or returns the result with -PassThru). Needs the managed uv only when the repository holds Python, and the
    source tree (Assert-SourceTree).
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
        # --output-format concise prints one '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 means
        # findings, anything above it means ruff itself failed.
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

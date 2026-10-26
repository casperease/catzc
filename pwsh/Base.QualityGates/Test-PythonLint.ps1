<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-quality-gates/Test-PythonLint.ps1.md"
  header: "generated"
---
#>

function Test-PythonLint {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    Assert-SourceTree

    $scope = @(Get-PythonCheckScope)
    $issues = [System.Collections.Generic.List[string]]::new()
    if ($scope.Count -gt 0) {
        # One '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 is findings, above it ruff failed.
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

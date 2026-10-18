<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Test-PythonLint.ps1
    name: test-python-lint
    filetype: ps1
    kind: function
    subkind: gate
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
    cites:
      - ADR-AUTO-PY#8
---
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

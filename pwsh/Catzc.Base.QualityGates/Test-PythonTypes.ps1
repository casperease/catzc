<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-PythonTypes.ps1
    name: test-python-types
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-PythonTypes.Tests.ps1
    docs: "[Test-PythonTypes.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-PythonTypes.ps1.md)"
    cites:
      - ADR-AUTO-PY-EVERYFILETYPECHECKED
---
#>

function Test-PythonTypes {
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
        $check = Invoke-PythonWorkspaceTool -Tool 'pyright --outputjson' -File $scope -ConfigOption '--project'
        $start = $check.Output.IndexOf('{')
        $end = $check.Output.LastIndexOf('}')
        if ($check.ExitCode -notin 0, 1 -or $start -lt 0 -or $end -lt $start) {
            throw "pyright could not check the Python files (exit $($check.ExitCode)):`n$($check.Full)"
        }
        $report = $check.Output.Substring($start, $end - $start + 1) | ConvertFrom-Json -AsHashtable
        $repositoryRoot = Get-RepositoryRoot
        foreach ($diagnostic in @($report['generalDiagnostics'])) {
            if ($diagnostic['severity'] -notin 'error', 'warning') {
                continue
            }
            $file = [System.IO.Path]::GetRelativePath($repositoryRoot, $diagnostic['file']).Replace('\', '/')
            $position = $diagnostic['range']['start']
            $rule = $diagnostic.Contains('rule') ? "$($diagnostic['rule']) " : ''
            $message = ($diagnostic['message'] -split '\r?\n' | ForEach-Object Trim) -join ' '
            $issues.Add("${file}:$($position['line'] + 1):$($position['character'] + 1): $($diagnostic['severity']) $rule$message")
        }
    }

    Write-QualityGateReport -Subject python-types -Title Test-PythonTypes -Issues $issues.ToArray() `
        -Facts ([ordered]@{ Files = $scope.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}

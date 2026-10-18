<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/private/Get-PythonCheckScope.ps1
    folder: private
    name: get-python-check-scope
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
    cites:
      - ADR-AUTO-PY#8
---
#>

function Get-PythonCheckScope {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $repositoryRoot = Get-RepositoryRoot
    foreach ($testFolder in @(Get-LanguageTestFolders)) {
        if ($testFolder.Language -eq 'python') {
            $testFolder.Folder
        }
    }

    $pythonRoot = (Get-Config -Config python).ResolveRoot($repositoryRoot) + '/'
    $others = [System.Collections.Generic.List[string]]::new()
    foreach ($tracked in @(Get-GitTrackedPath '.')) {
        if ($tracked.EndsWith('.py', [System.StringComparison]::Ordinal) -and -not $tracked.StartsWith($pythonRoot, [System.StringComparison]::Ordinal)) {
            $others.Add($tracked)
        }
    }
    $others.Sort([System.StringComparer]::Ordinal)
    foreach ($relative in $others) {
        [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($repositoryRoot, $relative))
    }
}

<#
---
catzc:
  immutable:
    with_body_sha: "4985e20e2027"
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
    docs: "[Get-PythonCheckScope.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-PythonCheckScope.ps1.md)"
    cites:
      - ADR-AUTO-PY-EVERYFILELINTED
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

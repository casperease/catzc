<#
.SYNOPSIS
    Lists what the Python checks read: every Python test folder, and every tracked .py file outside the Python root.
.DESCRIPTION
    Every .py file the repository holds takes the Python checks
    ([ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)): the Python test folders
    (Get-LanguageTestFolders, language python — a folder, so a new test file counts before it is committed), and the
    tracked .py files anywhere else, such as the agent helpers under .claude/ (Get-GitTrackedPath, read from the index).
.OUTPUTS
    [string] Full paths: the test folders first, in their order, then the other files in ordinal order. Nothing when
    the repository holds no Python.
.EXAMPLE
    $scope = @(Get-PythonCheckScope)
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

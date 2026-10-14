<#
.SYNOPSIS
    Maps changed repository paths to the test files that cover them.
.DESCRIPTION
    The tests half of Test-Change's plan, by convention alone (one function per file,
    [ADR-PWSH-ONEFUNC](/docs/adr/pwsh/one-function-per-file.md)): a changed test file is itself; a changed function file
    automation/<Module>/[private/]<Name>.ps1 is covered by automation/<Module>/tests/<Name>.Tests.ps1; a changed C# type
    automation/<Module>/types/<Type>.cs by automation/<Module>/tests/types/<Type>.Tests.ps1. Only test files that exist
    are returned, as repo-relative, '/'-separated paths, sorted ordinally, each once; a change no convention covers
    contributes nothing.
.PARAMETER Path
    The changed repo-relative, '/'-separated paths.
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.OUTPUTS
    [string]
.EXAMPLE
    Get-ChangeTestFile -Path 'automation/Catzc.Base.Files/Get-GitChangedPath.ps1' -RepositoryRoot (Get-RepositoryRoot)
#>
function Get-ChangeTestFile {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory, Position = 0)]
        [AllowEmptyCollection()]
        [string[]] $Path,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $tests = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    foreach ($changed in $Path) {
        $candidate = if ($changed -match '\.Tests\.ps1$') {
            $changed
        }
        elseif ($changed -match '^(?<module>automation/[^/.][^/]*)/(private/)?(?<name>[^/]+)\.ps1$') {
            "$($Matches['module'])/tests/$($Matches['name']).Tests.ps1"
        }
        elseif ($changed -match '^(?<module>automation/[^/.][^/]*)/types/(?<type>[^/]+)\.cs$') {
            "$($Matches['module'])/tests/types/$($Matches['type']).Tests.ps1"
        }
        else {
            $null
        }
        if ($candidate -and [System.IO.File]::Exists([System.IO.Path]::Combine($RepositoryRoot, $candidate))) {
            [void]$tests.Add($candidate)
        }
    }
    $tests
}

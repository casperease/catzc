<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PWSH-ONEFUNC
---
#>

<#
.SYNOPSIS
    Maps changed repository paths to the test files that cover them.
.DESCRIPTION
    Naming convention only: a change with no existing test file beside its convention adds nothing, never a guess.
.PARAMETER Path
    The changed repo-relative, '/'-separated paths.
.PARAMETER RepositoryRoot
    The repository root the paths are relative to.
.PARAMETER Module
    Widen to every test file of each module a change touches.
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
        [string] $RepositoryRoot,

        [switch] $Module
    )

    $tests = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
    if ($Module) {
        $modules = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($changed in $Path) {
            if ($changed -match '^(?<module>automation/[^/.][^/]*)/') {
                [void]$modules.Add($Matches['module'])
            }
        }
        foreach ($moduleFolder in $modules) {
            $testsFolder = [System.IO.Path]::Combine($RepositoryRoot, $moduleFolder, 'tests')
            if (-not [System.IO.Directory]::Exists($testsFolder)) {
                continue
            }
            # Test files sit at most two levels below tests/ (tests/types/); the third level is headroom.
            foreach ($file in Get-ChildPath $testsFolder -File -Filter '*.Tests.ps1' -Depth 3) {
                [void]$tests.Add(([System.IO.Path]::GetRelativePath($RepositoryRoot, $file) -replace '\\', '/'))
            }
        }
        return $tests
    }
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

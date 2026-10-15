<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
    kind: automation-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-PWSH-ONEFUNC
  config:
    synopsis: Maps changed repository paths to the test files that cover them.
    description: |-
      The tests half of Test-Change's plan, by convention alone (one function per file,
      [ADR-PWSH-ONEFUNC](/docs/adr/pwsh/one-function-per-file.md)): a changed test file is itself; a changed function file
      automation/<Module>/[private/]<Name>.ps1 is covered by automation/<Module>/tests/<Name>.Tests.ps1; a changed C# type
      automation/<Module>/types/<Type>.cs by automation/<Module>/tests/types/<Type>.Tests.ps1. Only test files that exist
      are returned, as repo-relative, '/'-separated paths, sorted ordinally, each once; a change no convention covers
      contributes nothing. With -Module, a change anywhere under automation/<Module>/ (dot folders excepted) brings in
      every test file under that module's tests/ instead.
    parameters:
      Path: The changed repo-relative, '/'-separated paths.
      RepositoryRoot: The repository root the paths are relative to.
      Module: Widen to every test file of each module a change touches.
    outputs: '[string]'
    examples:
      - Get-ChangeTestFile -Path 'automation/Catzc.Base.Files/Get-GitChangedPath.ps1' -RepositoryRoot (Get-RepositoryRoot)
---
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

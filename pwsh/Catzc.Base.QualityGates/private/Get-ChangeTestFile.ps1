<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Get-ChangeTestFile.ps1
    folder: private
    name: get-change-test-file
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
    docs: "[Get-ChangeTestFile.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Get-ChangeTestFile.ps1.md)"
    cites:
      - ADR-PWSH-ONEFUNC
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
    $modulePattern = '^(?<module>' + [regex]::Escape((Get-CatzcModulesFolder)) + '/[^/.][^/]*)/'
    if ($Module) {
        $modules = [System.Collections.Generic.SortedSet[string]]::new([System.StringComparer]::Ordinal)
        foreach ($changed in $Path) {
            if ($changed -match $modulePattern) {
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
        elseif ($changed -match ($modulePattern + '(private/)?(?<name>[^/]+)\.ps1$')) {
            "$($Matches['module'])/tests/$($Matches['name']).Tests.ps1"
        }
        elseif ($changed -match ($modulePattern + 'types/(?<type>[^/]+)\.cs$')) {
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

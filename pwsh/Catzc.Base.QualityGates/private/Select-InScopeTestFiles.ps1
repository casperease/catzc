<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Select-InScopeTestFiles.ps1
    folder: private
    name: select-in-scope-test-files
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
    test: pwsh/Catzc.Base.QualityGates/tests/Select-InScopeTestFiles.Tests.ps1
    docs: "[Select-InScopeTestFiles.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Select-InScopeTestFiles.ps1.md)"
---
#>

function Select-InScopeTestFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $fileLookup = [System.Collections.Generic.HashSet[string]]::new([string[]] $TestFiles, [System.StringComparer]::OrdinalIgnoreCase)
    $inScopeFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $testsByFile = [System.Collections.Generic.Dictionary[string, System.Collections.Generic.List[object]]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file -or -not $fileLookup.Contains($file)) {
            continue
        }
        if (-not $testsByFile.ContainsKey($file)) {
            $testsByFile[$file] = [System.Collections.Generic.List[object]]::new()
        }
        $testsByFile[$file].Add($test)
        if (Test-TestInRunScope -Test $test -ExcludeTag $ExcludeTag) {
            [void]$inScopeFiles.Add($file)
        }
    }

    $kept = [System.Collections.Generic.List[string]]::new()
    $outOfScope = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $TestFiles) {
        if ($inScopeFiles.Contains($file) -or -not $testsByFile.ContainsKey($file)) {
            $kept.Add($file)
        }
        else {
            $outOfScope.AddRange($testsByFile[$file])
        }
    }

    [pscustomobject]@{
        Files           = $kept.ToArray()
        OutOfScopeTests = $outOfScope.ToArray()
    }
}

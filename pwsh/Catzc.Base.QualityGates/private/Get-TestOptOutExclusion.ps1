<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/private/Get-TestOptOutExclusion.ps1.md"
  warning: "Generated Header"
---
#>

function Get-TestOptOutExclusion {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        $Discovery,

        [Parameter(Mandatory)]
        [string[]] $Tag,

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [string[]] $TestFiles
    )

    $fileLookup = [System.Collections.Generic.HashSet[string]]::new([string[]] $TestFiles, [System.StringComparer]::OrdinalIgnoreCase)
    $excluded = [System.Collections.Generic.List[object]]::new()
    $excludedByFile = [ordered]@{}
    $runnableFiles = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($test in @($Discovery.Tests)) {
        # The test's run file: its test file, or the Go test folder of a Go bridge test.
        $file = Get-TestRunFile -Test $test
        if (-not $file -or -not $fileLookup.Contains($file)) {
            continue
        }

        # Out of the run's scope by tier or category: neither excluded by the opt-out tag nor runnable.
        if (-not (Test-TestInRunScope -Test $test -ExcludeTag $ExcludeTag)) {
            continue
        }
        $level = Get-TestBlockTag -Test $test -Valid ([Catzc.Base.Timeouts.TestTiers]::Names)
        $category = Get-TestBlockTag -Test $test -Valid 'logic', 'integrity'

        if ((Get-TestBlockTag -Test $test -Valid $Tag).Count -eq 0) {
            [void]$runnableFiles.Add($file)
            continue
        }

        $excluded.Add([pscustomobject]@{
                File         = $file
                ExpandedPath = $test.ExpandedPath
                Level        = $level -join ','
                Category     = $category -join ','
            })
        $excludedByFile[$file] = $true
    }

    $fullyExcluded = @($excludedByFile.Keys | Where-Object { -not $runnableFiles.Contains($_) })
    [pscustomobject]@{
        Tests              = @($excluded)
        FullyExcludedFiles = $fullyExcluded
        RemainingFiles     = @($TestFiles | Where-Object { $_ -notin $fullyExcluded })
    }
}

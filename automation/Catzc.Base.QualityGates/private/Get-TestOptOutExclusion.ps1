<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
    kind: automation-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: private
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#31
  config:
    synopsis: Lists the tests a test run's opt-out tag removes from a run, so the exclusion is visible, never silent.
    description: |-
      The build run (Test-CatzcBuild) excludes every test tagged 'source-only'
      ([ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)) and must count
      and list each one it leaves out. This walks the run's discovery and returns, for every test in the run's
      files that resolves to the tag along its block chain (Get-TestBlockTag — own It-tags, then each ancestor),
      one row — but only when the run would otherwise have executed it: a test whose tier or category is already
      excluded by the run's level/category filter is out of scope either way, so it is neither listed nor counted.
      It also returns the files left with nothing to run (every in-scope test carries the tag), which the caller
      drops from the work-list so no worker loads the modules for an empty file.
    parameters:
      Discovery: The run's discovery-only Pester result (Get-TestDiscovery).
      Tag: The opt-out tag(s) — 'source-only' for the build run.
      ExcludeTag: The run's tier/category exclude tags (Get-TestExcludeTag); tests resolving to one of them are out of scope.
      TestFiles: The run's test files; tests outside them are ignored.
    outputs: |-
      [pscustomobject] with Tests (rows of File, ExpandedPath, Level, Category, in discovery order),
      FullyExcludedFiles (files whose every in-scope test carries the tag), and RemainingFiles (-TestFiles without
      them, order kept).
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

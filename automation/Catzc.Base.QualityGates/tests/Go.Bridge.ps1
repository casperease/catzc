# The Go bridge: one shared Pester file the harness runs once per Go test folder, as a Pester container whose data
# names the folder and the engine entry (ConvertTo-PesterRunTarget). It is not a *.Tests.ps1 file, so no path scan
# runs it without that data.
#
# Discovery reads the folder's Go tests from its *_test.go files (Get-GoTestCases), so every Go test becomes one
# Pester test, tagged L2 (a real tool and a real engine,
# [ADR-AUTO-TEST#9](/docs/adr/automation/test-automation.md#rule-adr-auto-test9)) plus its category from its name
# (TestIntegrity* is integrity, everything else logic). The run calls Invoke-GoTest once for the module
# (Get-GoTestOutcomes): each test then passes, fails with the Go output, or skips as Go did; with no managed go at
# the pinned version every test skips with tool_go_missing
# ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8)). The tests start the engine in
# processes of their own, so the file runs in the greedy phase
# ([ADR-AUTO-TEST#26](/docs/adr/automation/test-automation.md#rule-adr-auto-test26)).
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'GoTestFolder', Justification = 'Read in the BeforeDiscovery block, which the analyzer does not follow.')]
param(
    [Parameter(Mandatory)]
    [string] $GoTestFolder,

    # The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.
    [string] $EntryScript
)

BeforeDiscovery {
    $script:goSuite = & (Get-Module Catzc.Base.QualityGates) {
        param($folder)
        $mapped = @(Get-GoTestFolders | Where-Object { $_.Folder -eq $folder })
        if ($mapped.Count -ne 1) {
            throw "$folder is not a Go test folder of a catzc module (Get-GoTestFolders)."
        }
        @{ Module = $mapped[0].Module; Cases = @(Get-GoTestCases -Folder $folder) }
    } $GoTestFolder
}

Describe "Go tests of $($script:goSuite.Module)" -Tag 'L2', 'greedy' -ForEach @(@{ Module = $script:goSuite.Module; Cases = $script:goSuite.Cases; Entry = $EntryScript }) {
    BeforeAll {
        $script:goOutcomes = & (Get-Module Catzc.Base.QualityGates) {
            param($module, $cases, $entry)
            Get-GoTestOutcomes -Module $module -Case $cases -EntryScript $entry
        } $Module $Cases $Entry
    }

    foreach ($goCase in $Cases) {
        It $goCase.Title -Tag $goCase.Category -ForEach @(@{ Key = $goCase.Key }) {
            $outcome = $script:goOutcomes[$Key]
            if ($outcome.Outcome -eq 'skip') {
                Set-ItResult -Skipped -Because $outcome.Reason
                return
            }
            if ($outcome.Outcome -eq 'fail') {
                throw $outcome.Message
            }
        }
    }
}

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
    kind: private-function
    module: Catzc.Base.QualityGates
    visibility: private
    adrs:
      - ADR-AUTO-TEST#31
---
#>

<#
.SYNOPSIS
    Chooses a test run's test files: every file under the test paths, narrowed by rule, by tier and category scope, and
    by the run's opt-out tag.
.DESCRIPTION
    Throws when -Rule or the opt-out tag leaves nothing to run; an empty tier is vacuously green instead.
.PARAMETER TestPath
    The run's 'tests' folders.
.PARAMETER Discovery
    The run's discovery-only Pester result (Get-TestDiscovery).
.PARAMETER Rule
    The wanted ADR rule citations ('ADR-<CODE>#<n>'); empty for no rule filter.
.PARAMETER ExcludeTag
    The run's tier/category exclude tags (Get-TestExcludeTag).
.PARAMETER OptOutTag
    The run's opt-out tag(s); empty for none.
.PARAMETER RunDirectory
    The run's folder, where the opt-out exclusion list is written.
.PARAMETER EntryPoint
    The entry point's name, for the error when the opt-out tag leaves nothing to run.
.OUTPUTS
    [pscustomobject] with Files (the work-list, in run order), ExcludeTag (the exclude tags plus the opt-out tag),
    OutOfScopeRows (NotRun rows for the scope filter's dropped files), and OptOutExcludedTests.
#>
function Select-TestRunFiles {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath,

        [Parameter(Mandatory)]
        $Discovery,

        [AllowEmptyCollection()]
        [string[]] $Rule = @(),

        [AllowEmptyCollection()]
        [string[]] $ExcludeTag = @(),

        [AllowEmptyCollection()]
        [string[]] $OptOutTag = @(),

        [Parameter(Mandatory)]
        [string] $RunDirectory,

        [Parameter(Mandatory)]
        [string] $EntryPoint
    )

    # Get-TestAutomationTestFiles returns its files as ONE array object (`, $array`): cast it, never wrap it in @().
    [string[]] $testFiles = Get-TestAutomationTestFiles -TestPath $TestPath

    if ($Rule.Count -gt 0) {
        $testFiles = @(Select-RuleTaggedFiles -TestFile $testFiles -Discovery $Discovery -Rule $Rule)
        if ($testFiles.Count -eq 0) {
            throw "No test cites $($Rule -join ', ') — nothing to run for -Rule."
        }
    }

    $scope = Select-InScopeTestFiles -Discovery $Discovery -ExcludeTag $ExcludeTag -TestFiles $testFiles
    $testFiles = @($scope.Files)
    $outOfScopeRows = @(ConvertTo-TestAutomationRowSet -Result ([pscustomobject]@{ Tests = @($scope.OutOfScopeTests) }))

    $optOutExcludedTests = @()
    if ($OptOutTag.Count -gt 0) {
        $optOutExclusion = Get-TestOptOutExclusion -Discovery $Discovery -Tag $OptOutTag -ExcludeTag $ExcludeTag -TestFiles $testFiles
        $optOutExcludedTests = @($optOutExclusion.Tests)
        $ExcludeTag = @($ExcludeTag) + @($OptOutTag)
        $testFiles = @($optOutExclusion.RemainingFiles)
        Write-TestOptOutExclusion -Tests $optOutExcludedTests -Tag $OptOutTag -RunDirectory $RunDirectory
        if ($testFiles.Count -eq 0 -and $optOutExcludedTests.Count -gt 0) {
            throw "Every test in scope carries $($OptOutTag -join ', ') — nothing to run in $EntryPoint."
        }
    }

    [pscustomobject]@{
        Files               = $testFiles
        ExcludeTag          = @($ExcludeTag)
        OutOfScopeRows      = $outOfScopeRows
        OptOutExcludedTests = $optOutExcludedTests
    }
}

<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
    folder: private
    name: select-test-run-files
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
    test: pwsh/Catzc.Base.QualityGates/tests/Select-TestRunFiles.Tests.ps1
    docs: "[Select-TestRunFiles.ps1.md](docs/references/pwsh/catzc-base-qualitygates/private/Select-TestRunFiles.ps1.md)"
    cites:
      - ADR-AUTO-TEST-SOURCEONLYTAG
---
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

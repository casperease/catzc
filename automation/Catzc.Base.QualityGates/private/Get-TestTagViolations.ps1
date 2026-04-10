<#
.SYNOPSIS
    Lists every Pester test that is missing — or ambiguous on — a required tag axis.
.DESCRIPTION
    Runs a discovery-only Pester pass (Run.SkipRun) over the given test folders so EVERY test is inspected
    regardless of run level or tag filters, then resolves each test's tier (L0-L3) and category
    (logic|integrity) via Get-TestLevelTag / Get-TestCategoryTag (nearest contributing block wins). A test is
    a violation when an axis resolves to zero tags (missing) or to more than one on its nearest contributing
    block (ambiguous). Returns one object per violating test: @{ Test; File; Reason }. Test-Automation calls
    this to enforce that every test carries exactly one tier and one category tag. See the test-automation ADR.
    Pester must already be loaded (Test-Automation lazy-loads it before calling this).
.PARAMETER TestPath
    One or more 'tests' folders to discover.
#>
function Get-TestTagViolations {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory)]
        [string[]] $TestPath
    )

    $config = New-PesterConfiguration
    $config.Run.Path = $TestPath
    $config.Run.SkipRun = $true
    $config.Run.PassThru = $true
    $config.Output.Verbosity = 'None'
    $discovered = Invoke-Pester -Configuration $config

    $violations = foreach ($test in $discovered.Tests) {
        $reasons = @()

        $tierTags = Get-TestBlockTag -Test $test -Valid 'L0', 'L1', 'L2', 'L3'
        if ($tierTags.Count -ne 1) {
            $detail = if ($tierTags.Count) {
                ': ' + ($tierTags -join ',')
            }
            else {
                ''
            }
            $reasons += "tier resolves to $($tierTags.Count) (need exactly one of L0-L3)$detail"
        }

        $categoryTags = Get-TestBlockTag -Test $test -Valid 'logic', 'integrity'
        if ($categoryTags.Count -ne 1) {
            $detail = if ($categoryTags.Count) {
                ': ' + ($categoryTags -join ',')
            }
            else {
                ''
            }
            $reasons += "category resolves to $($categoryTags.Count) (need exactly one of logic|integrity)$detail"
        }

        if ($reasons) {
            [pscustomobject]@{
                Test   = $test.ExpandedName
                File   = $test.ScriptBlock.File
                Reason = $reasons -join '; '
            }
        }
    }

    , @($violations)
}

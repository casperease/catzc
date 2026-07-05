<#
.SYNOPSIS
    Lists every Pester test that is missing — or ambiguous on — a required tag axis.
.DESCRIPTION
    Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run
    level or tag filters, and resolves each test's tier (L0-L3) and category (logic|integrity) via
    Get-TestLevelTag / Get-TestCategoryTag (nearest contributing block wins). A test is a violation when an
    axis resolves to zero tags (missing) or to more than one on its nearest contributing block (ambiguous).
    Returns one object per violating test: @{ Test; File; Reason }. Test-Automation calls this to enforce
    that every test carries exactly one tier and one category tag. See the test-automation ADR.
.PARAMETER Discovery
    The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.
#>
function Get-TestTagViolations {
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param(
        [Parameter(Mandatory)]
        $Discovery
    )

    $violations = foreach ($test in $Discovery.Tests) {
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

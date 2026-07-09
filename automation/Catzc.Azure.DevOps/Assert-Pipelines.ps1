<#
.SYNOPSIS
    Asserts the pipelines/ tree obeys the naming-and-placement contract (ADR-PIPE-NAME); throws on any
    violation — the gate half of the pipeline-layout check.
.DESCRIPTION
    Runs Test-Pipelines (the query form) and throws a single, collected error listing every violation when
    the tree is non-compliant; returns silently when it is clean. This is the throwing guard the way
    Assert-* pairs with Test-* elsewhere, and the form wired into the Test-Automation L2 suite so a
    mis-named or misplaced pipeline fails CI.

    See Test-Pipelines for the rules enforced (ADR-PIPE-NAME:1/2/3/4/6) and docs/adr/pipelines/
    pipeline-naming-and-placement.md for the contract itself.
.PARAMETER Path
    The pipelines/ directory to check. Defaults to `<repo>/pipelines`.
.EXAMPLE
    Assert-Pipelines
.EXAMPLE
    Assert-Pipelines -Path ./pipelines
#>
function Assert-Pipelines {
    [CmdletBinding()]
    param(
        [string] $Path
    )

    $params = @{}
    if ($Path) {
        $params.Path = $Path
    }
    $violations = @(Test-Pipelines @params)

    if ($violations.Count -eq 0) {
        Write-Message 'All pipelines satisfy the naming-and-placement contract (ADR-PIPE-NAME).'
        return
    }

    $detail = ($violations | ForEach-Object { "  [$($_.Rule)] $($_.File): $($_.Message)" }) -join "`n"
    throw "$($violations.Count) pipeline naming/placement violation(s) found (ADR-PIPE-NAME):`n$detail"
}

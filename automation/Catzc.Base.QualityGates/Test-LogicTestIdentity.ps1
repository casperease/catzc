<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-REPO-LANG
---
#>

<#
.SYNOPSIS
    Quality gate: no LOGIC test may name a live production identity (a real customer, subscription, org, template, or
    ADO project) as a code string literal — the tag-aware, comment-blind enforcer of the test/live zone
    separation.
.DESCRIPTION
    Adding a customer to customer.yml bans it from logic tests at once: the forbidden set is derived, not listed.
    [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3),
    [ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35),
    [ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md#comment1)
.PARAMETER Path
    The default needs the source tree (Assert-SourceTree); an explicit list works in either mode.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md#comment2)
.PARAMETER OutputFolder
    The report base folder. Defaults to <out>/test-logic-test-identity.
.PARAMETER PassThru
    Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
.OUTPUTS
    None (throws on findings), or the result object with -PassThru.
.EXAMPLE
    Test-LogicTestIdentity
.EXAMPLE
    $r = Test-LogicTestIdentity -PassThru; $r.Issues
#>
function Test-LogicTestIdentity {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The forbidden live-identity map, keyed by token, derived from the shipped config.
    $live = @{}
    foreach ($identity in (Get-LiveIdentityTokens)) {
        $live[$identity.Token] = $identity
    }

    if (-not $Path) {
        # The default set is every test file of the catzc source tree — tests never ship in a build.
        Assert-SourceTree
        $automationRoot = Join-Path (Get-RepositoryRoot) 'automation'
        $Path = [System.IO.Directory]::EnumerateFiles($automationRoot, '*.Tests.ps1', [System.IO.SearchOption]::AllDirectories) |
            Where-Object { $_ -notmatch '[\\/]\.vendor[\\/]' } |
            Sort-Object
    }

    # Text-scan first: the AST parse is the whole cost and about 95% of files hold no live token, so skip those.
    # [comment:3](/docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md#comment3)
    $exactTokens = @($live.Values | Where-Object { $_.MatchMode -eq 'exact' } | ForEach-Object { $_.Token })
    $tokenRegex = if ($exactTokens.Count) {
        [regex]::new('\b(' + (($exactTokens | ForEach-Object { [regex]::Escape($_) }) -join '|') + ')\b',
            [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    }
    else {
        $null
    }
    $identityParamRegex = [regex]::new('-(Environment|Env|Shortcode)\b',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)

    $issues = [System.Collections.Generic.List[string]]::new()
    foreach ($file in $Path) {
        $text = [System.IO.File]::ReadAllText($file)
        if (-not (($tokenRegex -and $tokenRegex.IsMatch($text)) -or $identityParamRegex.IsMatch($text))) {
            continue
        }
        foreach ($finding in (Get-LogicTestIdentityFinding -Path $file -LiveToken $live)) {
            $issues.Add("$(ConvertTo-RepoRelativePath $finding.File):$($finding.Line): $($finding.Message)")
        }
    }

    Write-QualityGateReport -Subject logic-test-identity -Title Test-LogicTestIdentity -Issues $issues.ToArray() `
        -Facts ([ordered]@{ FileCount = @($Path).Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}

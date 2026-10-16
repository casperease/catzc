<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
    kind: gate-function
    language: powershell
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#{3,35}
      - ADR-REPO-LANG
  config:
    synopsis: |-
      Quality gate: no LOGIC test may name a live production identity (a real customer, subscription, org, template, or
      ADO project) as a code string literal — the tag-aware, comment-blind enforcer of the test/live zone
      separation.
    description: |-
      The forbidden set is DERIVED from the shipped config (Get-LiveIdentityTokens), so it is always current —
      add a customer to customer.yml and it is immediately banned from logic tests. Each test file is classified
      by its Pester tags from the AST (Get-LogicTestIdentityFinding): a pure-logic file is scanned for
      live-identity string literals; an integrity or *.Integrity.Tests.ps1 file is skipped; a file mixing both
      is reported as needing a split.

      This is itself an INTEGRITY check (it reads the shipped config and the whole test tree), so it is tagged
      `integrity` where a Pester test wraps it. A quality gate
      ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends through
      Write-QualityGateReport, which writes out/test-logic-test-identity/, prints every finding as
      '<file>:<line>: <message>', and throws once listing them all; -PassThru returns the result instead.

      Stage 1 matches the DISTINCTIVE identities exactly (customers, subscriptions, org, templates, deployable
      units, ADO project); environment names (dev/test/preprod/prod) are a later, position-aware stage.
    parameters:
      Path: |-
        Test files to check. Defaults to every *.Tests.ps1 under automation/ (excluding vendored modules) — the
        catzc source tree, so the default needs the source mode (Assert-SourceTree); an explicit -Path works in
        either.
      OutputFolder: The report base folder. Defaults to <out>/test-logic-test-identity.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount }) instead of throwing.
    outputs: None (throws on findings), or the result object with -PassThru.
    examples:
      - Test-LogicTestIdentity
      - '$r = Test-LogicTestIdentity -PassThru; $r.Issues'
---
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
        # Test files reach four levels below automation (module, tests, types, file); vendored modules are pruned by the walk.
        $Path = Get-ChildPath $automationRoot -File -Filter '*.Tests.ps1' -Depth 4 -PruneVendor $true |
            Sort-Object
    }

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

<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
    kind: gate-function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-LANG
  config:
    synopsis: |-
      Quality gate: no shipped config may carry a TEST-fixture identity in its data — the reverse of
      Test-LogicTestIdentity, closing the other half of the language-zone separation.
    description: |-
      A shipped `configs/*.yml` or `infrastructure/**` file is the live zone: it names real identities.
      A fixture identity (acme/globex, tst, alpha, core_lower, widget, …) appearing in one is a leak — a test
      fixture committed as production data. The forbidden set is DERIVED from the fixture configs
      (Get-FixtureIdentityTokens), so it is always current.

      The scan parses each config with the YAML reader and inspects the parsed KEYS and scalar VALUES — never the
      raw text — so it is comment-blind by construction: a config comment illustrating `[acme, globex]` is not
      data and is not flagged, while a real `have_customers: [acme]` value is. The terminology registry (which
      DEFINES the fixture tokens) is excluded.

      It also checks that the two identity sets are disjoint: a fixture token that is also a live identity
      (Get-LiveIdentityTokens, derived from the shipped config) is an issue, whatever -Path names.

      A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): it ends
      through Write-QualityGateReport, which writes out/test-config-identity-hygiene/, prints every finding, and
      throws once listing them all; -PassThru returns the result instead. It reads the shipped config, so a Pester
      test wrapping it is `integrity`. It needs the source tree: the fixture identities live in the repository's
      tests/, so the source-tree guard (Assert-SourceTree) throws in build mode.
    parameters:
      Path: |-
        Config files to check. Defaults to every module `configs/*.yml` (except the terminology registry) and every
        `infrastructure/**` yml.
      OutputFolder: The report base folder. Defaults to <out>/test-config-identity-hygiene.
      PassThru: Return a result object ({ Subject; IssueCount; Issues; ReportPath; FileCount; LiveTokens }) instead of throwing.
    outputs: None (throws on findings), or the result object with -PassThru.
---
#>

function Test-ConfigIdentityHygiene {
    [CmdletBinding()]
    param(
        [string[]] $Path,

        [string] $OutputFolder,

        [switch] $PassThru
    )

    # The forbidden set comes from the test fixtures, which exist only in the catzc source tree.
    Assert-SourceTree

    $fixture = [System.Collections.Generic.HashSet[string]]::new(
        [string[]] (Get-FixtureIdentityTokens), [System.StringComparer]::OrdinalIgnoreCase)

    $root = Get-RepositoryRoot
    if (-not $Path) {
        $terminology = 'configs/terminology.yml'
        # A module's configs sit three levels below automation (module, configs, file); infrastructure ymls reach five.
        $moduleConfigs = Get-ChildPath (Join-Path $root 'automation') -File -Filter '*.yml' -Depth 3 -PruneVendor $true |
            Where-Object { $_ -match '[\\/]configs[\\/][^\\/]+\.yml$' -and ($_ -replace '\\', '/') -notlike "*$terminology" }
        $infrastructureRoot = Join-Path $root 'infrastructure'
        $infrastructureConfigs = if ([System.IO.Directory]::Exists($infrastructureRoot)) {
            Get-ChildPath $infrastructureRoot -File -Filter '*.yml' -Depth 5
        }
        else {
            @()
        }
        $Path = @($moduleConfigs) + @($infrastructureConfigs) | Sort-Object
    }

    $findings = [System.Collections.Generic.List[object]]::new()
    foreach ($file in $Path) {
        $parsed = [System.IO.File]::ReadAllText($file) | ConvertFrom-Yaml -Ordered

        # Iterative walk of the parsed structure — keys and scalar values only, so comments never enter.
        $stack = [System.Collections.Generic.Stack[object]]::new()
        $stack.Push([System.Tuple]::Create([object] $parsed, ''))
        while ($stack.Count -gt 0) {
            $current = $stack.Pop()
            $node = $current.Item1
            $nodePath = $current.Item2

            if ($node -is [System.Collections.IDictionary]) {
                foreach ($key in @($node.Keys)) {
                    $keyText = "$key"
                    if ($fixture.Contains($keyText)) {
                        $findings.Add([pscustomobject]@{ File = $file; Token = $keyText; Location = "$nodePath/$keyText (key)" })
                    }
                    $stack.Push([System.Tuple]::Create([object] $node[$key], "$nodePath/$keyText"))
                }
            }
            elseif ($node -is [string]) {
                if ($fixture.Contains($node)) {
                    $findings.Add([pscustomobject]@{ File = $file; Token = $node; Location = $nodePath })
                }
            }
            elseif ($node -is [System.Collections.IEnumerable]) {
                $index = 0
                foreach ($item in $node) {
                    $stack.Push([System.Tuple]::Create([object] $item, "$nodePath[$index]"))
                    $index++
                }
            }
        }
    }

    $issues = [System.Collections.Generic.List[string]]::new()

    # The two identity sets are disjoint: a fixture token that is also a live identity is no fixture at all.
    $liveTokens = @(Get-LiveIdentityTokens)
    foreach ($live in $liveTokens) {
        if ($fixture.Contains($live.Token)) {
            $issues.Add("fixture identity '$($live.Token)' is also a live identity ($($live.Kind) in $($live.Source)) — a test fixture must be distinct from every live identity")
        }
    }

    foreach ($finding in $findings) {
        $issues.Add("$(ConvertTo-RepoRelativePath $finding.File): fixture identity '$($finding.Token)' at $($finding.Location) — a shipped config must name a live identity")
    }

    Write-QualityGateReport -Subject config-identity-hygiene -Title Test-ConfigIdentityHygiene -Issues $issues `
        -Facts ([ordered]@{ FileCount = @($Path).Count; LiveTokens = $liveTokens.Count }) -OutputFolder $OutputFolder -PassThru:$PassThru
}

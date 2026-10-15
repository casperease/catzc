---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-LogicTestIdentity.ps1.md
    kind: comment-page
    body_sha: "67ef064c5b03"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
Test files to check. Defaults to every *.Tests.ps1 under automation/ (excluding vendored modules) — the
catzc source tree, so the default needs the source mode (Assert-SourceTree); an explicit -Path works in
either.
```

## comment:3

Above `$exactTokens = @($live.Values | Where-Object { $_.MatchMode -eq 'exact' } |...`.

```text
Parse only files that COULD carry a finding — a provable SUPERSET, so no leak is ever skipped. A finding
needs either an exact-match token as a string-literal value (which therefore appears word-bounded in the
source — `'apex'`, `-Customer apex`) or an ambiguous env/shortcode bound to an identity parameter (so the
parameter name is in the source). Every other file cannot match and is skipped parse-free — the AST parse
is the whole cost, and ~95% of the tree contains no live token at all, so this is a cheap text scan for
them. Word boundaries keep 2-char shortcodes (ap/nv/de/…) from matching inside ordinary words.
```

## comment:4

Above `$exactTokens = @($live.Values | Where-Object { $_.MatchMode -eq 'exact' } |...`.

```text
Parse only files that COULD carry a finding — a provable SUPERSET, so no leak is ever skipped. A finding
needs either an exact-match token as a string-literal value (which therefore appears word-bounded in the
source — `'apex'`, `-Customer apex`) or an ambiguous env/shortcode bound to an identity parameter (so the
parameter name is in the source). Every other file cannot match and is skipped parse-free — the AST parse
is the whole cost, and ~95% of the tree contains no live token at all, so this is a cheap text scan for
them. Word boundaries keep 2-char shortcodes (ap/nv/de/…) from matching inside ordinary words.
```

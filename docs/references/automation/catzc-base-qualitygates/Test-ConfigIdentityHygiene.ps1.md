---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-ConfigIdentityHygiene.ps1.md
    kind: comment-page
    body_sha: "502cbc97a77e"
    adrs:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
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
```

## comment:2

Section `.PARAMETER Path` of the comment-based help.

```text
Config files to check. Defaults to every module `configs/*.yml` (except the terminology registry) and every
`infrastructure/**` yml.
```

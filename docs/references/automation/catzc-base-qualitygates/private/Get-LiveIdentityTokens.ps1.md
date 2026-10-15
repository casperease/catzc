---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
    kind: comment-page
    body_sha: "00b2b559575b"
    adrs:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The authoritative source of "what is a live identity" is the shipped config itself, not a hand-kept list:
reading it here means the forbidden set is always current (add a customer to customer.yml and it is
automatically banned from logic tests). Which values are identities is declared by the module that owns
them, in its configs/identity-tokens.yml (IdentityTokensConfig): this function lists those owners and walks
each declared path, so it never names another module's config and a bundle without those modules simply
yields no tokens from them. A declaration may name only a config its own module owns. Every value is read
through Get-Config (the one global reader,
[ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md)), so a test isolates this function by mocking
Get-Config to fixtures.

This is STAGE 1 — the DISTINCTIVE identities only (customers, subscriptions, org, deployable units,
template names, ADO project). Environment names (dev/test/preprod/prod) are deliberately excluded: they
are ambiguous ('test' is pervasive in test code) and belong to a later, position-aware stage. Each record
carries its Source and a Suggest string so a finding can name the fixture the test should have used.

Backs Test-LogicTestIdentity ([ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md)): a logic test
whose AST contains a string literal equal to one of
these tokens (or a delimited segment of one) is using a live identity where a fixture belongs
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

## comment:2

Above `$add = {`.

```text
MatchMode governs HOW the finder matches a token: 'exact' — a distinctive identity flagged wherever it
appears as a literal; 'position' — an ambiguous identity (an environment name like 'test'/'dev') flagged
ONLY when bound to an identity parameter (-Environment/-Env/-Shortcode), never as bare prose.
```

## comment:3

Above `$walk = {`.

```text
Walks one rule's path from a node: a key segment steps in, a '*' steps into every entry of a map (leaving
out an entry that sets skip_when), and the end of the path yields the scalar or the map's keys.
```

## comment:4

Above `foreach ($owner in @(Get-Config -Config identity-tokens -ListOwners)) {`.

```text
The identities each owning module declares about its own configs (configs/identity-tokens.yml): customers,
the org, subscriptions, environments (position match — ambiguous words such as 'test'), the ADO project.
```

## comment:5

Above `$templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'`.

```text
NOTE: deployable-unit and pipeline names (globs.yml) are deliberately NOT included in Stage 1. The
generic ones (`automation`, `infrastructure`, `templates`, `shared`) are structural folder names that
appear as legitimate string literals throughout the tests, so matching them is pure false-positive; the
customer-named units (apex/nova/flux) are already covered by the customer keys above. A later stage may
add the DISTINCTIVE units with an explicit folder-collision exclusion.
```

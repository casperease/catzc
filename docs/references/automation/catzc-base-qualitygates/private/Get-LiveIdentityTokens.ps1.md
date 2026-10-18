---
catzc:
  immutable:
    with_body_sha: d46bcccdd685
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-live-identity-tokens-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Derives the set of LIVE production identity tokens — the customers, subscriptions, org, deployable units, template names, and ADO project
the shipped config maps to — that a hermetic LOGIC test must never name.

### description

The authoritative source of "what is a live identity" is the shipped config itself, not a hand-kept list: reading it here means the
forbidden set is always current (add a customer to customer.yml and it is automatically banned from logic tests). Which values are
identities is declared by the module that owns them, in its configs/identity-tokens.yml (IdentityTokensConfig): this function lists those
owners and walks each declared path, so it never names another module's config and a bundle without those modules simply yields no tokens
from them. A declaration may name only a config its own module owns. Every value is read through Get-Config (the one global reader,
[ADR-CONF-LOADING](../../../../adr/configuration/module-config-loading.md)), so a test isolates this function by mocking Get-Config to
fixtures.

This is STAGE 1 — the DISTINCTIVE identities only (customers, subscriptions, org, deployable units, template names, ADO project).
Environment names (dev/test/preprod/prod) are deliberately excluded: they are ambiguous ('test' is pervasive in test code) and belong to a
later, position-aware stage. Each record carries its Source and a Suggest string so a finding can name the fixture the test should have
used.

Backs Test-LogicTestIdentity ([ADR-REPO-LANG](../../../../adr/repository/domain-language-separation.md)): a logic test whose AST contains a
string literal equal to one of these tokens (or a delimited segment of one) is using a live identity where a fixture belongs
([ADR-AUTO-TEST#3](../../../../adr/automation/test-automation.md#rule-adr-auto-test3)).

### outputs

`[object[]]` One record per token: @{ Token; Kind; Source; Suggest }.

## comment:1

Above `$add = {`, written with `#`.

```text
MatchMode governs HOW the finder matches a token: 'exact' — a distinctive identity flagged wherever it
appears as a literal; 'position' — an ambiguous identity (an environment name like 'test'/'dev') flagged
ONLY when bound to an identity parameter (-Environment/-Env/-Shortcode), never as bare prose.
```

## comment:2

Above `$walk = {`, written with `#`.

```text
Walks one rule's path from a node: a key segment steps in, a '*' steps into every entry of a map (leaving
out an entry that sets skip_when), and the end of the path yields the scalar or the map's keys.
```

## comment:3

Above `foreach ($owner in @(Get-Config -Config identity-tokens -ListOwners)) {`, written with `#`.

```text
The identities each owning module declares about its own configs (configs/identity-tokens.yml): customers,
the org, subscriptions, environments (position match — ambiguous words such as 'test'), the ADO project.
```

## comment:4

Above `$templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'`, written with `#`.

```text
NOTE: deployable-unit and pipeline names (globs.yml) are deliberately NOT included in Stage 1. The
generic ones (`automation`, `infrastructure`, `templates`, `shared`) are structural folder names that
appear as legitimate string literals throughout the tests, so matching them is pure false-positive; the
customer-named units (apex/nova/flux) are already covered by the customer keys above. A later stage may
add the DISTINCTIVE units with an explicit folder-collision exclusion.
```

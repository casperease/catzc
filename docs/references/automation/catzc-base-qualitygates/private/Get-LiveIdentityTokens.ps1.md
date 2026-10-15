---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
    kind: comment-page
    body_sha: "74371658e8c9"
---

# automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `$add = {`.

```text
MatchMode governs HOW the finder matches a token: 'exact' — a distinctive identity flagged wherever it
appears as a literal; 'position' — an ambiguous identity (an environment name like 'test'/'dev') flagged
ONLY when bound to an identity parameter (-Environment/-Env/-Shortcode), never as bare prose.
```

## comment:7

Above `$walk = {`.

```text
Walks one rule's path from a node: a key segment steps in, a '*' steps into every entry of a map (leaving
out an entry that sets skip_when), and the end of the path yields the scalar or the map's keys.
```

## comment:8

Above `foreach ($owner in @(Get-Config -Config identity-tokens -ListOwners)) {`.

```text
The identities each owning module declares about its own configs (configs/identity-tokens.yml): customers,
the org, subscriptions, environments (position match — ambiguous words such as 'test'), the ADO project.
```

## comment:9

Above `$templatesRoot = Join-Path (Get-RepositoryRoot) 'infrastructure/templates'`.

```text
NOTE: deployable-unit and pipeline names (globs.yml) are deliberately NOT included in Stage 1. The
generic ones (`automation`, `infrastructure`, `templates`, `shared`) are structural folder names that
appear as legitimate string literals throughout the tests, so matching them is pure false-positive; the
customer-named units (apex/nova/flux) are already covered by the customer keys above. A later stage may
add the DISTINCTIVE units with an explicit folder-collision exclusion.
```

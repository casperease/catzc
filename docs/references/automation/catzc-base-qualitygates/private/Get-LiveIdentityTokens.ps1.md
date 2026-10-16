---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LiveIdentityTokens.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/private
    name: get-live-identity-tokens-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d46bcccdd685
---

# automation/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

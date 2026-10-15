---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md
    kind: comment-page
    body_sha: "84d57a3a8726"
---

# automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Assert-SourceTree`.

```text
Every fixture config tree (tests/assets/config/) — the identity-bearing azure.yml and customer.yml a
logic test redirects Get-Config to. Enumerate all of them and union their identities. Test fixtures live
only in the catzc source tree (tests never ship in a build), hence the guard.
```

## comment:5

Above `foreach ($token in 'widget', 'gadget', 'faketool') {`.

```text
Neutral in-memory fixtures that never live in a config file — the globset and tool fixtures logic tests
construct inline.
```

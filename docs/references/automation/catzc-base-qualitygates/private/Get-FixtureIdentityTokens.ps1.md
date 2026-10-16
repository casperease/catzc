---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-FixtureIdentityTokens.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "8d247d750dd4"
---

# automation/Catzc.Base.QualityGates/private/Get-FixtureIdentityTokens.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Assert-SourceTree`, written with `#`.

```text
Every fixture config tree (tests/assets/config/) — the identity-bearing azure.yml and customer.yml a
logic test redirects Get-Config to. Enumerate all of them and union their identities. Test fixtures live
only in the catzc source tree (tests never ship in a build), hence the guard.
```

## comment:2

Above `foreach ($token in 'widget', 'gadget', 'faketool') {`, written with `#`.

```text
Neutral in-memory fixtures that never live in a config file — the globset and tool fixtures logic tests
construct inline.
```

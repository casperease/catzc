---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Show-Cats.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "862f59ab1f30"
---

# automation/Catzc.Base.Docs/Show-Cats.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$entries = Get-CatsAdrIndex`, written with `#`.

```text
Plain assignment (not @(...)): the getter returns a comma-wrapped array
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md) exemplar),
which assignment receives intact — wrapping it again in @() would nest it one level too deep.
```

## comment:2

Above `$entryEnforcers = $enforcers[($rule.Id -replace ':', '#')]`, written with `#`.

```text
Show what mechanically enforces this rule (tests + analyzer rules), if anything —
the citation is the '#' form of the registry id ([index](/docs/adr/index.md)).
```

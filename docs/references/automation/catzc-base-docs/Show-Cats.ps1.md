---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/Show-Cats.ps1.md
    kind: comment-page
    body_sha: e8e3ca4bd481
---

# automation/Catzc.Base.Docs/Show-Cats.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$entries = Get-CatsAdrIndex`.

```text
Plain assignment (not @(...)): the getter returns a comma-wrapped array
([ADR-AUTO-CACHE](/docs/adr/automation/caching.md) exemplar),
which assignment receives intact — wrapping it again in @() would nest it one level too deep.
```

## comment:6

Above `$entryEnforcers = $enforcers[($rule.Id -replace ':', '#')]`.

```text
Show what mechanically enforces this rule (tests + analyzer rules), if anything —
the citation is the '#' form of the registry id ([index](/docs/adr/index.md)).
```

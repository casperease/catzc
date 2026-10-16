---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "3941eb2d4d4b"
---

# automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$levels = [System.Collections.Generic.List[object]]::new()`, written with `#`.

```text
The tag levels to union: the test's own It-tags, then each ancestor block (root excluded) — the same walk
Get-TestBlockTag makes, but accumulating across every level instead of stopping at the first that
contributes, because provenance is a set (a Describe rule and an inner It rule both hold).
```

## comment:2

Above `if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {`, written with `#`.

```text
Strict, case-sensitive citation grammar: only a well-formed 'ADR-<CODE>#<n>' contributes. A
miscased or malformed tag is Get-TestTagViolations' concern, not a coverage row's.
```

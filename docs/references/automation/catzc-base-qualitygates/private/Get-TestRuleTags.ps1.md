---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md
    kind: comment-page
    body_sha: be440c28f856
---

# automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `$levels = [System.Collections.Generic.List[object]]::new()`.

```text
The tag levels to union: the test's own It-tags, then each ancestor block (root excluded) — the same walk
Get-TestBlockTag makes, but accumulating across every level instead of stopping at the first that
contributes, because provenance is a set (a Describe rule and an inner It rule both hold).
```

## comment:6

Above `if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {`.

```text
Strict, case-sensitive citation grammar: only a well-formed 'ADR-<CODE>#<n>' contributes. A
miscased or malformed tag is Get-TestTagViolations' concern, not a coverage row's.
```

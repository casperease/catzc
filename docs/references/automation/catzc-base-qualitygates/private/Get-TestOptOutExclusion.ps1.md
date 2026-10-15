---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md
    kind: comment-page
    body_sha: b47be7b8b77a
    adrs:
      - ADR-AUTO-TEST#31
---

# automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The build run (Test-CatzcBuild) excludes every test tagged 'source-only'
([ADR-AUTO-TEST#31](/docs/adr/automation/test-automation.md#rule-adr-auto-test31)) and must count
and list each one it leaves out. This walks the run's discovery and returns, for every test in the run's
files that resolves to the tag along its block chain (Get-TestBlockTag — own It-tags, then each ancestor),
one row — but only when the run would otherwise have executed it: a test whose tier or category is already
excluded by the run's level/category filter is out of scope either way, so it is neither listed nor counted.
It also returns the files left with nothing to run (every in-scope test carries the tag), which the caller
drops from the work-list so no worker loads the modules for an empty file.
```

## comment:2

Above `foreach ($test in @($Discovery.Tests)) {`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```

## comment:3

Above `foreach ($test in @($Discovery.Tests)) {`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```

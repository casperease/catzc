---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Test-TestInRunScope.ps1.md
    kind: reference
    body_sha: "6cde7d01226d"
    adrs: []
---

# automation/Catzc.Base.QualityGates/private/Test-TestInRunScope.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A test is in scope when neither its tier nor its category — each resolved along its block chain (Get-TestBlockTag,
nearest contributing block wins) — is one of the run's exclude tags (Get-TestExcludeTag). The one scope check
behind the work-list's scope filter (Select-InScopeTestFiles) and the opt-out exclusion (Get-TestOptOutExclusion),
so both agree on which tests a run would execute.
```

## comment:2

Above `$level = Get-TestBlockTag -Test $Test -Valid...`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```

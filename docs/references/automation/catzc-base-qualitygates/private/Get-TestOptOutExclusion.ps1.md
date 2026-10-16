---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestOptOutExclusion.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a41e47e5743f
---

# automation/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($test in @($Discovery.Tests)) {`, written with `#`.

```text
Get-TestBlockTag returns its matches as ONE array object (`, $ret`), so its result is used as-is, never
wrapped in @() — that would nest it and every count would read 1.
```

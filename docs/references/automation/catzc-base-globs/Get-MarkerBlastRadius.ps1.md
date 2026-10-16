---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: be7ee9e833a9
---

# automation/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($set in @(Get-GlobSet) + @(Get-ModuleGlobSet)) {`, written with `#`.

```text
Declared sets first (registry order), then the derived module sets — the same one-answer-per-set
shape either way.
```

---
catzc:
  derived:
    path: docs/references/infrastructure/modules/log-analytics.bicep.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "0d5279858354"
---

# infrastructure/modules/log-analytics.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `@description('Log Analytics workspace name.')`, written with `//`.

```text
Reusable bicep module: a Log Analytics workspace. Templates reference it with a relative `module`
declaration (../../modules/log-analytics.bicep); `az bicep build` inlines it.
```

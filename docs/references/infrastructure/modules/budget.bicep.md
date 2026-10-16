---
catzc:
  derived:
    path: docs/references/infrastructure/modules/budget.bicep.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4140fa185b2a"
---

# infrastructure/modules/budget.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `targetScope = 'subscription'`, written with `//`.

```text
Reusable bicep module: a cost budget at subscription scope, with one alert per threshold. Alerts go
to the holders of the listed subscription roles (Owner by default), so no email address is kept in
configuration. `az bicep build` inlines it.
```

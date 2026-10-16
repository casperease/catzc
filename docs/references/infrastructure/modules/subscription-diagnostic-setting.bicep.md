---
catzc:
  immutable:
    with_body_sha: "4371dd8a56dc"
    repo_status: locked
    path: docs/references/infrastructure/modules/subscription-diagnostic-setting.bicep.md
    folder: docs/references/infrastructure/modules
    name: subscription-diagnostic-setting-bicep
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/modules/subscription-diagnostic-setting.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `targetScope = 'subscription'`, written with `//`.

```text
Reusable bicep module: a diagnostic setting at subscription scope that sends the subscription's
activity log to a Log Analytics workspace (which may live in another subscription). Resource-level
settings use diagnostic-setting.bicep. `az bicep build` inlines it.
```

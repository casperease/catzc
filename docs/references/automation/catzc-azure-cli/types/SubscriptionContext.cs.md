---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/types/SubscriptionContext.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c0a980682507
---

# automation/Catzc.Azure.Cli/types/SubscriptionContext.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A snapshot of the az CLI's currently active subscription (the shape of `az account show`). Captured so
it can be saved and later restored around a subscription switch.
```

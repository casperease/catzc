---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/types/SubscriptionAccessState.cs.md
    folder: docs/references/automation/catzc-azure-cli/types
    name: subscription-access-state-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: ad60190f05ae
---

# automation/Catzc.Azure.Cli/types/SubscriptionAccessState.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Whether the current az CLI login can actually reach a given subscription, established by a real,
read-only ARM probe (not just by inspecting local session state). A point-in-time access check.
```

## comment:2

Above `public bool logged_in { get; }`, written with `//`.

```text
True when there is any active az login at all. On the failure path this separates "not logged in"
from "logged in but no access to this subscription".
```

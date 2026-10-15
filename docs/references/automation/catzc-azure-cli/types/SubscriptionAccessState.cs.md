# docs/references/automation/catzc-azure-cli/types/SubscriptionAccessState.cs.md

`automation/Catzc.Azure.Cli/types/SubscriptionAccessState.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Whether the current az CLI login can actually reach a given subscription, established by a real,
read-only ARM probe (not just by inspecting local session state). A point-in-time access check.
```

## comment:2

Above `public bool logged_in { get; }`.

```text
True when there is any active az login at all. On the failure path this separates "not logged in"
from "logged in but no access to this subscription".
```

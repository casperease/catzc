---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Uninstall-NodeJs.ps1.md
    kind: comment-page
    body_sha: "20e47d9821ef"
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Node/Uninstall-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `try {`.

```text
Managed uninstall best-effort; with -Remove a failure (a foreign install) is logged and the escalation
proceeds, without -Remove it propagates
([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-AzCli.ps1.md
    kind: comment-page
    body_sha: "8bc8a00ecd56"
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Toolchain/Uninstall-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `try {`.

```text
Managed uninstall best-effort. With -Remove a failure (a foreign install the manager cannot touch — the
exact case -Remove exists for) is logged and the escalation proceeds to Remove-AzCli; without -Remove it
propagates as a normal uninstall failure. Catching only under -Remove is the escalation's single stated
purpose, not general catch-and-continue
([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

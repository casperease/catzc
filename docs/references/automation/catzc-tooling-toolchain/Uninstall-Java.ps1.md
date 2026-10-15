---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md
    kind: comment-page
    body_sha: "064d273a3666"
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:5

Above `try {`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:6

Above `if ($env:JAVA_HOME) {`.

```text
Clean up JAVA_HOME. Each removal is announced where it happens, and only when there was something to
remove
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```

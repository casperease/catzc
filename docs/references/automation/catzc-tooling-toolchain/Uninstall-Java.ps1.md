---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md
    kind: comment-page
    body_sha: d7850c4b944b
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
    links: []
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from
$PROFILE) — the managed uninstall. For a Java installed OUTSIDE the tooling system (a foreign JDK, an apt
package on a uv-first box), escalate with -Remove -Force: the managed uninstall runs best-effort and then
falls through to Remove-Java, which evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:2

Section `.PARAMETER Remove` of the comment-based help.

```text
After the managed uninstall, escalate to Remove-Java to evict an off-config install. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
```

## comment:3

Above `try {`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:4

Above `if ($env:JAVA_HOME) {`.

```text
Clean up JAVA_HOME. Each removal is announced where it happens, and only when there was something to
remove
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```

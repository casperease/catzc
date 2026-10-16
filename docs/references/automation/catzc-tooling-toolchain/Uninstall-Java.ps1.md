---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain
    name: uninstall-java-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "059a1111bc79"
    adrs:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `try {`, written with `#`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:2

Above `if ($env:JAVA_HOME) {`, written with `#`.

```text
Clean up JAVA_HOME. Each removal is announced where it happens, and only when there was something to
remove
([ADR-AUTO-CONSOLE#11](/docs/adr/automation/console-output-matters.md#rule-adr-auto-console11)).
```

---
catzc:
  immutable:
    with_body_sha: "059a1111bc79"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Java.ps1.md
    folder: docs/references/automation/catzc-tooling-toolchain
    name: uninstall-java-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-CONSOLE#11
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Uninstalls Java via the platform package manager.

### description

Removes Java through the configured manager and clears JAVA_HOME (on Unix, removes the marker block from $PROFILE) — the managed uninstall.
For a Java installed OUTSIDE the tooling system (a foreign JDK, an apt package on a uv-first box), escalate with -Remove -Force: the managed
uninstall runs best-effort and then falls through to Remove-Java, which evicts whatever the configured manager did not own
([ADR-AUTO-REMOVE#5](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).

### parameter Version

Java version to uninstall. Defaults to the locked version in Get-ToolConfig.

### parameter Remove

After the managed uninstall, escalate to Remove-Java to evict an off-config install. Pair with -Force to actually remove; -Remove alone
reports the plan ([ADR-AUTO-REMOVE#4](../../../adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).

### parameter Force

Confirm the destructive Remove-Java step of the escalation. Ignored without -Remove.

### example 1

```powershell
Uninstall-Java
```

### example 2

```powershell
Uninstall-Java -Remove -Force
```

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

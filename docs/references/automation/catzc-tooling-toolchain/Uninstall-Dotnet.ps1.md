---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Uninstall-Dotnet.ps1.md
    kind: comment-page
    body_sha: b5e6892715e1
    adrs:
      - ADR-AUTO-ONEJOB#5
      - ADR-AUTO-REMOVE#4
      - ADR-AUTO-REMOVE#5
---

# automation/Catzc.Tooling.Toolchain/Uninstall-Dotnet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Removes the managed user-space install directory and cleans persistent environment variables (DOTNET_ROOT
and PATH) — the managed uninstall. Idempotent — skips if the directory does not exist.

Nothing is deleted while a process holds the install open (Get-DotnetInstallHolder — an MSBuild node, the
compiler server, an editor's C# language server): the uninstall throws, naming each holder, so a locked file
can never leave a half-deleted install. -Force stops exactly those named processes first. On Windows it also
refuses to run elevated: the managed install is user-space and needs no elevation, so an elevated shell means
the target is a machine-scope .NET (C:\Program Files\dotnet), which winget removes — never this one.

For a .NET installed OUTSIDE the
tooling system (a system SDK, an apt package), escalate with -Remove -Force: the managed uninstall runs
best-effort and then falls through to Remove-Dotnet, which evicts whatever the configured manager did not
own ([ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:2

Section `.PARAMETER Remove` of the comment-based help.

```text
After the managed uninstall, escalate to Remove-Dotnet to evict an off-config install. Pair with -Force to
actually remove; -Remove alone reports the plan
([ADR-AUTO-REMOVE#4](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove4)).
```

## comment:3

Section `.PARAMETER Force` of the comment-based help.

```text
Confirm the destructive steps: stop the processes named as holding the install open, and — with -Remove —
the Remove-Dotnet eviction.
```

## comment:4

Above `try {`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

## comment:5

Above `try {`.

```text
Managed uninstall best-effort; with -Remove a failure is logged and the escalation proceeds, without
-Remove it propagates ([ADR-AUTO-ONEJOB#5](/docs/adr/automation/single-responsibility-functions.md#rule-adr-auto-onejob5),
[ADR-AUTO-REMOVE#5](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove5)).
```

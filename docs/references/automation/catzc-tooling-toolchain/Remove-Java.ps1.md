---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md
    kind: comment-page
    body_sha: "6e5e3076f9f1"
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Toolchain/Remove-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Deletes the JDK installation folder and removes it (and its bin
subdirectory) from the system-level PATH. Requires Administrator.
Auto-detects the install directory from Get-Command if not specified.

This is for JDK installations (Oracle, AdoptOpenJDK, etc.) that
are not managed by winget/brew/apt. If Java is managed by the
tooling system, use Uninstall-Java instead.
```

## comment:2

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-Java
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:3

Above `if ($IsLinux -or $IsMacOS) {`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```

## comment:4

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-Java
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:5

Above `if ($IsLinux -or $IsMacOS) {`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```

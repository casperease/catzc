---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Remove-NodeJs.ps1.md
    kind: comment-page
    body_sha: f24aedea85ff
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Node/Remove-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Deletes the Node.js installation folder and removes it from the
system-level PATH. Requires Administrator. Auto-detects the install
directory from Get-Command if not specified.

This is for Node.js installations that do not appear in Apps & Features
or winget. If Node.js is managed by winget, use Uninstall-NodeJs instead.
```

## comment:2

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-NodeJs
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
Gate: managed by our tooling system → refuse, redirect to Uninstall-NodeJs
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

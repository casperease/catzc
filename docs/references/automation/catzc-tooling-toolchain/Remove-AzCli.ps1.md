---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md
    kind: comment-page
    body_sha: "49397fd34c3d"
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Toolchain/Remove-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `if (Test-ExpectedPackageManager -Config $config) {`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli
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

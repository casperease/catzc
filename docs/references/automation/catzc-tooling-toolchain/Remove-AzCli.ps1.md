---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-AzCli.ps1.md
    kind: comment-page
    body_sha: d8ad6b7aea2e
    adrs:
      - ADR-AUTO-REMOVE#3
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Toolchain/Remove-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Test-ExpectedPackageManager -Config $config) {`, written with `#`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-AzCli
([ADR-AUTO-REMOVE#3](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove3)).
```

## comment:2

Above `if ($IsLinux -or $IsMacOS) {`, written with `#`.

```text
Unix: evict an off-config install by the mechanism that placed it (native package manager / uv-Python pip
/ stray binary); elevation is scoped to the mechanism
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)), so no admin assert
here.
```

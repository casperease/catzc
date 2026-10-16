---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Remove-Java.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4fef1899bf76"
    adrs:
      - ADR-AUTO-REMOVE#{3,6}
---

# automation/Catzc.Tooling.Toolchain/Remove-Java.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if (Test-ExpectedPackageManager -Config $config) {`, written with `#`.

```text
Gate: managed by our tooling system → refuse, redirect to Uninstall-Java
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

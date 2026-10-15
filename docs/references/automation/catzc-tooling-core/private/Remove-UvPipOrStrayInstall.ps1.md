---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Remove-UvPipOrStrayInstall.ps1.md
    kind: comment-page
    body_sha: "87b2bec6020f"
    adrs:
      - ADR-AUTO-REMOVE#6
---

# automation/Catzc.Tooling.Core/private/Remove-UvPipOrStrayInstall.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Called by Remove-LinuxToolInstall and Remove-MacToolInstall after each has tried its native package
manager (apt on Linux, brew on macOS). Neither step here needs elevation
([ADR-AUTO-REMOVE#6](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove6)): the pip removal is
the uv-scoped 'uv pip uninstall --system' (never a foreign system pip), and the stray delete removes only
the resolved binary. Private to Catzc.Tooling.Core.
```

## comment:2

Section `.PARAMETER Source` of the comment-based help.

```text
The resolved path of the tool's on-PATH binary (from Get-Command) — the caller resolves it once and passes
it in.
```

## comment:3

Above `if ([System.IO.File]::Exists($Source)) {`.

```text
Stray binary no manager owns — delete just the resolved file (a root-owned path fails the delete loudly
rather than being force-removed silently).
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Get-PackageTreePlan.ps1.md
    kind: reference
    body_sha: "82a85999900e"
    adrs:
      - ADR-AUTO-REMOVE#2
---

# automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Compares the files and folders under -Source with -Destination and returns paths relative to both roots, with
forward slashes:

  Directories  the folders the destination lacks, parents before children, so creating them in order works;
  Files        the files the destination lacks: the ones a copy adds, and the only ones an uninstall may delete;
  Kept         the files the destination already has: they belong to whoever placed them, so a copy leaves them alone.

Reads the filesystem only and changes nothing, so the plan can be recorded before the copy starts and an
interrupted copy is still covered by it
([ADR-AUTO-REMOVE#2](/docs/adr/automation/tool-removal-lifecycle.md#rule-adr-auto-remove2)).
```

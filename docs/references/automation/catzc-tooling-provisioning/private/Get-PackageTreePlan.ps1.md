---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Get-PackageTreePlan.ps1.md
    kind: comment-page
    body_sha: "367da616e1b9"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:2

Above `$sourceDirectories = [System.Collections.Generic.List[string]]::new()`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
plan must see every file, so no folder name is pruned and the depth is the
config's ceiling. A real package tree reaches ten levels, and a shallower bound would silently drop files from the copy.
```

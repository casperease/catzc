---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/private/Get-PackageTreePlan.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/private
    name: get-package-tree-plan-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c3f8c35af49c
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sourceDirectories = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): a copy
plan must see every file, so no folder name is pruned and the depth is the
config's ceiling. A real package tree reaches ten levels, and a shallower bound would silently drop files from the copy.
```

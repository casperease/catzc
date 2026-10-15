---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
    kind: comment-page
    body_sha: "9b868f2173d4"
---

# automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$helperName = 'Get-CatzcModuleRoot'`.

```text
The helper's own parameter metadata decides how each argument binds: which names (or unambiguous
prefixes, or aliases) mean -ChildPath / -Module, and which other parameters take a value (common
parameters such as -ErrorAction) so their value is never mistaken for the positional child path.
```

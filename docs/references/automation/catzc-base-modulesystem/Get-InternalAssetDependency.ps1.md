---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/Get-InternalAssetDependency.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: c7be191bd9d4
---

# automation/Catzc.Base.ModuleSystem/Get-InternalAssetDependency.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$helperName = 'Get-CatzcModuleRoot'`, written with `#`.

```text
The helper's own parameter metadata decides how each argument binds: which names (or unambiguous
prefixes, or aliases) mean -ChildPath / -Module, and which other parameters take a value (common
parameters such as -ErrorAction) so their value is never mistaken for the positional child path.
```

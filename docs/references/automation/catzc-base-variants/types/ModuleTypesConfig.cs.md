---
catzc:
  immutable:
    with_body_sha: f0e1ea2fadaf
    path: docs/references/automation/catzc-base-variants/types/ModuleTypesConfig.cs.md
    folder: docs/references/automation/catzc-base-variants/types
    name: module-types-config-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Variants/types/ModuleTypesConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class ModuleTypesConfig`, written with `//`.

```text
The one definition of what a module is, by type: where modules of each type are placed in the repository, and how a file path names its
module. Local to catzc and global to every file; a consumer extends it by a config fragment, which adds a type (checked after these) or
replaces the places of one (a map merges key by key, a list replaces).
```

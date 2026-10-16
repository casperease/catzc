---
catzc:
  immutable:
    with_body_sha: "1ee93ea7b2dd"
    repo_status: locked
    path: docs/references/automation/catzc-base-variants/types/ModulePlace.cs.md
    folder: docs/references/automation/catzc-base-variants/types
    name: module-place-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Variants/types/ModulePlace.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public sealed class ModulePlace`, written with `//`.

```text
A place under a root folder where modules of one type are found, and how a path in that place names its module:
folder  the first folder under the root, never a dot-prefixed one, with the prefix put before its PascalCase when there is one;
file    a file of the extension directly under the root, named without the extension;
root    the root folder itself, named by its last segment.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-base-variants/configs/module-types.yml.md
    folder: docs/references/automation/catzc-base-variants/configs
    name: module-types-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "494be9a602b7"
---

# automation/Catzc.Base.Variants/configs/module-types.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `module_types:`, written with `#`.

```text
The one definition of what a module is, by type: where modules of each type are placed, and how a path in a place names its module.
A place is a root folder and how a path under it names its module: `folder` is the first folder under the root (never a dot-prefixed one,
and with `prefix` put before its PascalCase), `file` is a file of the extension directly under the root, and `root` is the root folder
itself. Types are checked in the order written, places in the order of their type, and the first to place a path names its module. A
consumer extends this in a config fragment, which adds a type (checked after these) or replaces the places of one.
```

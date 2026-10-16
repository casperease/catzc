---
catzc:
  immutable:
    with_body_sha: "0723f8f16b53"
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleFiles.cs.md
    folder: docs/references/automation/catzc-base-modulesystem/types
    name: module-files-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
One module's entry in configs/files.yml (`modules: <module>: { packages: { <package>: [paths] } }`): the named
packages of repository-root-relative file artifacts the module owns beyond its own folder, which Copy-Automation
copies with it. Constructing one MAPS and VALIDATES the entry, collecting every violation into one throw:
  - the entry is a map whose only key is a non-empty 'packages' map;
  - each package name is snake_case;
  - each package is a non-empty list of non-empty paths (not a single string), each repository-root-relative and
    forward-slashed (not rooted, no '\', no '..' segment), as the file's own header declares.
Global package-name uniqueness spans modules, so FilesConfig checks it. Mirrors the YAML mapping (snake_case keys,
[ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```

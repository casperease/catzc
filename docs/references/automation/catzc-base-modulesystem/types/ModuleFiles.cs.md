---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/types/ModuleFiles.cs.md
    kind: comment-page
    body_sha: "3b618d2eeefb"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.ModuleSystem/types/ModuleFiles.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

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

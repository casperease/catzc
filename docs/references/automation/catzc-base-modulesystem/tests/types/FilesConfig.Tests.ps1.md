---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/types/FilesConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "9aca4bed1fea"
---

# automation/Catzc.Base.ModuleSystem/tests/types/FilesConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.FilesConfig' -Tag 'L0', 'logic' {`.

```text
The files.yml type (module -> packages, for Copy-Automation): constructing it maps and validates the parsed
YAML, so a malformed module->packages manifest never loads through Get-Config -Config files.
```

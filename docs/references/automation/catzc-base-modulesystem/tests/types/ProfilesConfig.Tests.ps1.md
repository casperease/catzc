---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/types/ProfilesConfig.Tests.ps1.md
    kind: test-asset
    body_sha: f53eacdd2aca
---

# automation/Catzc.Base.ModuleSystem/tests/types/ProfilesConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.ProfilesConfig' -Tag 'L0', 'logic' {`.

```text
The profiles.yml type: constructing it maps and validates the parsed YAML, so a malformed profile map never
loads through Get-Config -Config profiles.
```

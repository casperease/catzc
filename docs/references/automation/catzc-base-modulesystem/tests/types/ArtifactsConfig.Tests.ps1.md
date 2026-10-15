---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/types/ArtifactsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: d57bedc045b2
---

# automation/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.ArtifactsConfig' -Tag 'L0' {`.

```text
The artifacts.yml type: constructing it maps and validates the parsed YAML, so a malformed publish-target map
never loads through Get-Config -Config artifacts.
```

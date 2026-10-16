---
catzc:
  derived:
    path: docs/references/automation/catzc-base-modulesystem/tests/types/ArtifactsConfig.Tests.ps1.md
    kind: comment-page
    language: markdown
    filekind: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "4de5e814cbcc"
---

# automation/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.ArtifactsConfig' -Tag 'L0' {`, written with `#`.

```text
The artifacts.yml type: constructing it maps and validates the parsed YAML, so a malformed publish-target map
never loads through Get-Config -Config artifacts.
```

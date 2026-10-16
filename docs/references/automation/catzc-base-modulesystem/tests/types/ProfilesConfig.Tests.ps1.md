---
catzc:
  immutable:
    with_body_sha: f5eb83d81bb9
    path: docs/references/automation/catzc-base-modulesystem/tests/types/ProfilesConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests/types
    name: profiles-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.ModuleSystem/tests/types/ProfilesConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.ProfilesConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
The profiles.yml type: constructing it maps and validates the parsed YAML, so a malformed profile map never
loads through Get-Config -Config profiles.
```

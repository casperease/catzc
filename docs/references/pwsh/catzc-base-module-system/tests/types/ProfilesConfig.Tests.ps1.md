# pwsh/Catzc.Base.ModuleSystem/tests/types/ProfilesConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.ProfilesConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
The profiles.yml type: constructing it maps and validates the parsed YAML, so a malformed profile map never
loads through Get-Config -Config profiles.
```

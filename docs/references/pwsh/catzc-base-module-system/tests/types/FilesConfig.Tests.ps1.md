# pwsh/Catzc.Base.ModuleSystem/tests/types/FilesConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Catzc.Base.ModuleSystem.FilesConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
The files.yml type (module -> packages, for Copy-CatzcModule): constructing it maps and validates the parsed
YAML, so a malformed module->packages manifest never loads through Get-Config -Config files.
```

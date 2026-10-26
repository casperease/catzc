# pwsh/Base.Languages/tests/types/LanguageNaming.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$config.LayoutFolders() | Should -Be @('private', 'extension', 'types',...`, written with `#`.

```text
The editor extension's folder and the run-list folder are laid out but neither live nor shipped, like the
shared tests folder.
```

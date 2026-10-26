# pwsh/Base.Languages/private/Get-ModuleTestFolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$folder = $Module`, written with `#`.

```text
A module's test folder is named from its folder, which drops the namespace its track declares, in the language's folder
case; a name no track's namespace prefixes is its own folder.
```

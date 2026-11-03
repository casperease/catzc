# pwsh/Base.Languages/Export-JavaScriptModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$rendered = $null`, written with `#`.

```text
An extension the repository registers carries no tracked package.json; its folder is rendered from the registry, the one
living version of the manifest, packed from memory, and the temporary render is removed at once.
```

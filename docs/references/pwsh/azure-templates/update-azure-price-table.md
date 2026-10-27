# pwsh/Azure.Templates/Update-AzurePriceTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$prices = [ordered]@{}`, written with `#`.

```text
Each meter takes the first tier priced above 0, since a free allowance is a meter's common first tier; a meter that matches
nothing is reported, never loosened.
```

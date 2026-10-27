# pwsh/Azure.Templates/tests/HealthModel.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$resources = $script:slots[0].Main.resources`, written with `#`.

```text
The serialized workbook is built by string() over the resource group's name, which the evaluator leaves unresolved, so the
queries are read from the module's declared health model.
```

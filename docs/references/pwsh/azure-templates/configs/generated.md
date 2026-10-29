# pwsh/Azure.Templates/configs/generated.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `Set-BicepTemplateConfiguration:`, written with `#`.

```text
It writes one configuration file per template, environment and customer from the parameters it is given, which are read outside the tree,
so a rolled-off file could not be rendered again.
```

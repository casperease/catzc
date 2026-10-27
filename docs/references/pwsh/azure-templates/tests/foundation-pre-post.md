# pwsh/Azure.Templates/tests/Foundation.PrePost.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `$expected =...`, written with `#`.

```text
A resource's properties come back as written, so the endpoint is told by where it deploys: the vault's endpoint module,
under the slot's derived endpoint name.
```

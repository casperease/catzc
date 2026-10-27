# pwsh/Azure.Templates/types/BicepRoleAssignment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public string scope { get; }`, written with `//`.

```text
subscription, resourceGroup, or the '<provider>/<type>/<name>' of the one resource the role is assigned on; the empty string when
that resource's name does not resolve offline.
```

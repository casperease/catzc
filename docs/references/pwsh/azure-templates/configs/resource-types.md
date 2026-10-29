# pwsh/Azure.Templates/configs/resource-types.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `patterns:`, written with `#`.

```text
A type line holds only what differs from the defaults on ResourceTypesConfig: pattern long, charset [a-z0-9-].
not_names, the *Name key suffixes the name gate skips, is absent: the default on ResourceTypesConfig (SkuName, SubnetName) holds.
```

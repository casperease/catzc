# pwsh/Azure/types/NetworkFlow.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class NetworkFlow : Catzc.Base.Objects.DictionaryRecord`, written with `//`.

```text
One inbound flow a subnet's security group allows; every other inbound flow from the network is denied. Subnets are named by role, so a
flow holds for every subnet of that role in every network.
```

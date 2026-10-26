# pwsh/Azure/types/AzureEnvironment.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
A resolved environment identity: a named deployment environment paired with the subscription that
serves it. The root of the identity graph (AzureEnvironment → AzureSubscription → Tenant). The name and
short codes compose Azure resource names per the naming standard. Mirrors an `environments` entry in
configs/azure.yml (joined to its serving subscription), so the property names are the YAML keys.
```

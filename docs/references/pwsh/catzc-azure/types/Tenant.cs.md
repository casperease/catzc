# pwsh/Catzc.Azure/types/Tenant.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
An Entra ID tenant — the directory boundary that owns one or more subscriptions. The leaf of the
resolved identity graph (Tenant ← AzureSubscription ← AzureEnvironment). Mirrors one entry of the
`tenants` map in configs/azure.yml, so the property names are the YAML keys verbatim.
```

# infrastructure/templates/foundation/main.bicep

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `param location string = resourceGroup().location`, written with `//`.

```text
foundation — the once-per-subscription baseline: a Log Analytics workspace + a Key Vault. Deployed
once per subscription (envs nsub/psub), in the shared subscription and in each customer's. The Key
Vault holds shared secrets for that subscription — notably the SQL admin password that consuming
templates reference. Resources come from the reusable modules in infrastructure/modules/.
```

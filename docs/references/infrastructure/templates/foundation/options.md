# infrastructure/templates/foundation/options.yml

The per-template options of foundation, the once-per-subscription baseline (Log Analytics and Key Vault). Its Key Vault holds the SQL admin
password that consuming templates reference.

## Classification

The classification follows [ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md) and is inferred, never declared in `options.yml`.

- The environment kind is subscription — configs use the per-subscription envs (`nsub`, `psub`), once per subscription.

The slot is per config, not a template property: foundation's configs simply carry no slot.

## comment:1

Above `names:`, written with `#`.

```text
The names the build derives from the namer; a slot never writes one (Test-BicepResourceNames). The vault endpoint's names derive here
too; the bootstrap pass turns the endpoint off with deployKeyVaultPrivateEndpoint, not by blanking a name.
```

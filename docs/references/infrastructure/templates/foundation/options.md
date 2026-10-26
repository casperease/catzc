# infrastructure/templates/foundation/options.yml

The per-template options of foundation, the once-per-subscription baseline (Log Analytics and Key Vault). Its Key Vault holds the SQL admin
password that consuming templates reference.

## Classification

The classification follows [ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md).

- `environment_kind: subscription` — configs use the per-subscription envs (`nsub`, `psub`), once per subscription.

The slot is per config, not a template property: foundation's configs simply carry no slot.

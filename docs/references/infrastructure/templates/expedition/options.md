# infrastructure/templates/expedition/options.yml

The per-template options of expedition, the Well-Architected workload: storage and a SQL database behind private endpoints, landing in a
discovery network. It deploys into its own resource group, one per configuration slot.

## Classification

The classification follows [ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md).

- `environment_kind: standard` — configs use the standard envs (dev, test, preprod, prod), slotted per config.

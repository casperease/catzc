# pwsh/Azure.Templates/types/BicepSlot.cs

The typed record of one slot of a template that can be deployed: the unit that binds one config file to one coordinate of customer
(optional), environment and slot, which resolves to one subscription and one resource group. It nests into `BicepTemplate.slots`, so a
template fans out into one `BicepSlot` per deployable coordinate.

## Properties

- **`slot`** — the slot discriminator within the environment. The empty string, not null, is the base slot, kept as a sentinel because
  downstream resolves a slot by value (`slot -eq ''` for the base).
- **`subscription`** — the subscription this slot deploys into, resolved at discovery from the slot's coordinate: the one non-customer
  subscription serving the environment for a configuration-root config, or the customer's one subscription serving it for a
  `configuration/<customer>/` config. Always present.
- **`customer`** — the customer this slot is for, the configuration subfolder name (a customer key). The empty string, not null, marks a
  configuration-root (shared) slot, a sentinel because downstream filters by value (`customer -eq ''`).
- **`format`** — the config's source format from its extension, `yml` or `bicepparam`
  ([ADR-AZ-DATAMOD-BICEPPARAMSLOT](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-bicepparamslot)).

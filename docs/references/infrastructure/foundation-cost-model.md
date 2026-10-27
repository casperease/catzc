# foundation cost model

What one `foundation` slot costs a month. The model is `pwsh/Azure.Templates/configs/cost-model.yml`, priced from the checked-in
`pwsh/Azure.Templates/assets/cost-prices.json`; this page names what the model holds and never copies a price or a total. Cost is shaped by
configuration, per [ADR-AZ-LZ-COSTBYCLASS](../../drs/azure/landing-zones.md#rule-adr-az-lz-costbyclass). The article is
[foundation](foundation.md).

## The metered resources

- The Log Analytics workspace: the data ingested into it a month.
- The Key Vault: its operations, in units of 10,000.
- The flow-log storage account, where the slot has one: hot zone-redundant blob data stored, the cost exports included.
- Free or not yet modelled: the resource group, the action group, and the diagnostic settings.

## The budget

- The estimate of a slot is `Get-BicepCostEstimate foundation`, run on the compiled template.
- `foundation` deploys no budget of its own: the budget of its subscription is `discovery`'s, see
  [discovery cost model](discovery-cost-model.md).

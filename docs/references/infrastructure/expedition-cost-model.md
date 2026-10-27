# expedition cost model

What one `expedition` slot costs a month. The model is `pwsh/Azure.Templates/configs/cost-model.yml`, priced from the checked-in
`pwsh/Azure.Templates/assets/cost-prices.json`; this page names what the model holds and never copies a price or a total. Cost is shaped by
configuration, per [ADR-AZ-LZ-COSTBYCLASS](../../drs/azure/landing-zones.md#rule-adr-az-lz-costbyclass). The article is
[expedition](expedition.md).

## The metered resources

- The storage account: hot zone-redundant blob data stored.
- The SQL database: serverless General Purpose compute, by the vCore-hours it is active.
- The private endpoints of the blob service and of the SQL server: by the hour. Their Retail Prices API service is not yet known, so the
  estimate reports them as unpriced until the model names it.
- Free or not yet modelled: the SQL logical server, its auditing, and the registrations in the hub's private DNS zones.

## The budget

- The estimate of a slot is `Get-BicepCostEstimate expedition`, run on the compiled template.
- `expedition` deploys no budget of its own: the budget of the subscription it lands in is `discovery`'s, see
  [discovery cost model](discovery-cost-model.md).

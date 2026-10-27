# discovery cost model

What one `discovery` slot costs a month, and where its budget comes from. The model is `pwsh/Azure.Templates/configs/cost-model.yml`, priced
from the checked-in `pwsh/Azure.Templates/assets/cost-prices.json`; this page names what the model holds and never copies a price or a
total, so the numbers live in one place. The decision that cost is shaped by configuration is
[ADR-AZ-LZ-COSTBYCLASS](../../drs/azure/landing-zones.md#rule-adr-az-lz-costbyclass); the budget every landing zone deploys is
[ADR-AZ-LZ-COSTATTRIBUTION](../../drs/azure/landing-zones.md#rule-adr-az-lz-costattribution). The article is [discovery](discovery.md).

## The metered resources

- A hub's firewall, priced by its tier in `network.yml` `subscriptions.<hub>.firewall_sku`, which the model's `skus` reads for the
  subscription the estimate is for:
  - `Basic`: the deployment hours, the data processed, and two Standard static public IPs, the egress and the management address;
  - `Standard`: the deployment hours, the data processed, and one Standard static public IP, spread over the region's zones;
  - either tier: its resource-specific logs into `foundation`'s workspace.
- A hub's private DNS zones, priced by the region of each DNS zone, not by the ARM region.
- A spoke deploys no metered resource of its own: its firewall declaration has no tier, so no tier's meters apply.
- Free or not yet modelled: the virtual network, the network security groups, the route tables, the peerings, the policy assignments, the
  budget, the cost export and the anomaly alert. The firewall policy carries no meter of its own for the one firewall it serves.

## The budget

- The estimate of one slot is `Get-BicepCostEstimate discovery -Subscription <network.yml subscription>`, run on the compiled template.
- Its `Budget` is the estimate's monthly total times the model's `headroom`: the one derivation of a budget amount.
- Each slot's `budgetAmount` is at least that `Budget`; `Discovery.Budget.Tests.ps1` checks every compiled slot offline, from the checked-in
  price table.
- A meter missing from the price table is reported as unpriced and left out of the total, so the price table is refreshed with
  `Update-AzurePriceTable` when the model gains a meter.

# pwsh/Azure.Templates/tests/Get-Config.Integrity.Tests.ps1

The integrity tests of the shipped config assets and the real templates.

## Scope

Unlike the logic tests, these bind deliberately to the real `configs/azure.yml`, `configs/network.yml` and `infrastructure/templates/`. They
are the contract that what ships is internally consistent. They do not mock the `Resolve-ConfigEntry` (config discovery) or
`Get-BicepTemplatesRoot` seams, and nothing else depends on them.

## One assertion per set

The check makes one `Should` over the violating set. A `Should` per template slot would cost Pester's per-assertion price times the whole
discovered template tree.

## Customers

`slot.customer` is the raw token from the subscription, a key or a shortcode. It must resolve to a defined customer in `customer.yml`, and
`Get-AzureCustomer` throws otherwise.

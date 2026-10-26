# pwsh/Azure/private/Get-NetworkPlanViolations.ps1

The private join behind the network plan check. It compares the two typed configs, `network.yml` and `azure.yml`, and returns every
disagreement as a message. Neither type can see the other config, so the cross-config rule lives here, in PowerShell.

## help

### synopsis

Returns every way a network plan is out of sync with the azure config's environments and subscriptions.

### description

The cross-asset join of
[ADR-AZ-NETWORK-KEYEDBYENVIRONMENT](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-keyedbyenvironment) and
[ADR-AZ-NETWORK-NETWORKPERSUBSCRIPTION](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-networkpersubscription), over two
already-typed configs.

Environments: every network environment is a defined azure.yml environment (no ghost plan), and every STANDARD azure.yml environment has a
network entry. Per-subscription environments (nsub/psub) are exempt — they carry no vnet
([ADR-AZ-NETWORK-SUBSCRIPTIONENVIRONMENTSNONETWORK](../../../../drs/azure/azure-network-model.md#rule-adr-az-network-subscriptionenvironmentsnonetwork)).

Subscriptions: every network subscription is a defined azure.yml subscription (no ghost network), and every azure.yml subscription has one
of the right kind — a hub when it has no customer, a spoke when it has one. A spoke has exactly one workload subnet per standard environment
its subscription serves, named for that environment.

### parameter `Network`

The network plan (Get-Config -Config network).

### parameter `Azure`

The azure config (Get-Config -Config azure).

### outputs

`[string]` One message per violation; nothing when the two are in sync.

### example 1

```powershell
Get-NetworkPlanViolations -Network (Get-Config -Config network) -Azure (Get-Config -Config azure)
```

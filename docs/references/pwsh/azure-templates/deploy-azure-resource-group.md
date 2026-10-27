# pwsh/Azure.Templates/Deploy-AzureResourceGroup.ps1

The command that idempotently ensures a resource group exists in a given subscription and region.

## help

### synopsis

Idempotently ensures a resource group exists in a given subscription and region.

### description

Runs `az group exists`; if missing, runs `az group create` at the given region in the given subscription. The subscription + region are
resolved by the caller (Deploy-Bicep, from the deployment context) and passed in — this function does NOT re-resolve them from azure.yml, so
the RG is always created in the SAME subscription the deployment targets (including customer deploys).

A new group is created with the given tags. A group that already exists gets them merged in through `az tag update --operation Merge`, so a
tag another tool set on it stays.

Returns an ordered dictionary `{ name, provisioning_state }` where provisioning_state is 'Succeeded' (just created), 'Tagged' (already
existed, tags merged), 'Skipped' (already existed, no tags given), or 'DryRun'.

### parameter `SubscriptionId`

The subscription the resource group must live in (from the resolved deployment context).

### parameter `Region`

The Azure region to create the resource group in.

### parameter `ResourceGroup`

The resource group name to ensure.

### parameter `Tags`

The CAF tags the group carries, key to value: `Deploy-Bicep` passes the slot's `tags` parameter, the same tags its resources get. Empty by
default, which leaves an existing group untouched.

### parameter `DryRun`

Preview only — report the resource group that would be created and make no change.

### example 1

```powershell
Deploy-AzureResourceGroup -SubscriptionId $context.environment.subscription.id -Region westeurope -ResourceGroup rg-sample-dev
```

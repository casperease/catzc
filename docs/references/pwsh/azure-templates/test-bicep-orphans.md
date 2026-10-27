# pwsh/Azure.Templates/Test-BicepOrphans.ps1

The gate that compares the resource groups of the az session's subscription against the template configuration tree, so a group left behind
by a removed config is found, and reminds of the special slots to remove when their job is done.

## help

### synopsis

Lists every resource group of the org in the session's subscription that no template config derives, and names the special slots.

### description

Resolves the az session's subscription (Get-AzCliSessionSubscription), derives the resource group of every resource-group-target template
slot that subscription serves (Get-BicepResourceGroupName), and lists the subscription's resource groups (`az group list`). A group whose
name carries the azure.yml org segment and the `-rg` suffix, as every derived name does, but that no slot derives is an issue: a config was
removed and its group left behind. A group outside that naming belongs to someone else and is ignored. Every named slot the subscription
serves is listed in the report's facts as one to remove when its job is done. An ephemeral slot (a blue/green or a trial copy, such as
`dev-blu`, or the L3 test slot `l3`) has no file, so the group it leaves is one no slot derives, and the gate reports it as an issue until
it is removed.

### parameter `OutputFolder`

Where the gate report is written. Defaults to the shared report folder.

### parameter `PassThru`

Return the gate result instead of throwing on issues.

### example 1

```powershell
Test-BicepOrphans
```

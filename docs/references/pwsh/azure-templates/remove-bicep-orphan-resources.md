# pwsh/Azure.Templates/Remove-BicepOrphanResources.ps1

The cleanup that removes what a revert takes out of a template. Every template deploys `Incremental`, and ARM has no `Complete` mode at
subscription scope, so a resource a template no longer declares stays in Azure until it is deleted; this command deletes it. The production
and rollback paths of the DEPLOY pipelines run it after each resource-group deploy, with `-DryRun` first
([orphan removal](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-orphansneedresolvednames)).

## help

### synopsis

Deletes the resources of a slot's resource group that its compiled template no longer declares, and returns their ids.

### description

Resolves the deployment the way `Deploy-Bicep` does (`Get-BicepDeploymentContext`): the az session's subscription, pinned by
`-SubscriptionIdAssertIs` (required in a pipeline), the slot's resource group and the compiled template and parameters file. It evaluates
the template's resources with the slot's parameter values offline (the compliance evaluator), lists the group's resources
(`az resource list`), and takes every listed resource whose type and name no evaluated resource carries as an orphan, matched without regard
to case. Only what the listing can return is compared: the template's extension resources (any with a `scope`, such as role assignments,
locks and diagnostic settings) and child proxies (a child resource without a `location`) are left out, and a listed resource Azure creates
itself, named in `orphan-removal.yml` (a SQL server's `master` database by default), is never an orphan. When the name of any listable
evaluated resource does not resolve offline, such as one built by `format()` or `resourceId()`, the command deletes nothing: it returns the orphan candidates and then fails, naming the unresolved resources. Otherwise it deletes each orphan by id
(`az resource delete`) and returns the ids it deleted. A template deployed at subscription scope is refused, since several templates share
that scope, and a `DoNotRun` template is skipped.

### parameter `Environment`

Environment shortname of the slot.

### parameter `Template`

The template whose deployed resource group is cleaned up.

### parameter `Slot`

The named slot; empty for the base slot.

### parameter `SubscriptionIdAssertIs`

The subscription id the az session must target; required in a pipeline.

### parameter `ArtifactsFolder`

The build output the deploy used; required on a build agent, and a devbox builds the template when it is absent.

### parameter `DryRun`

Returns the orphans' ids and deletes nothing.

### example 1

```powershell
Remove-BicepOrphanResources nsub expedition -DryRun
```

### example 2

```powershell
Remove-BicepOrphanResources psub foundation -SubscriptionIdAssertIs 50a0ed00-000d-50b0-0000-000000000000 -ArtifactsFolder ./out/foundation
```

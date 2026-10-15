# docs/explanation/azure/read-the-session-guard-then-pick-slot.md

`Get-BicepDeploymentContext reads the session, guards it, then picks the slot`

```text
Get-BicepDeploymentContext resolves the session, applies the guard, then addresses the slot, in that order.

1  Get-CurrentAzSubscription       az account show: the session's active subscription
2  Get-AzCliSessionSubscription    the reverse lookup: the session's id -> { name, id, customer, tenant }
3  azure.yml                       the declared subscriptions the session's id is matched against
4  undeclared subscription         the throw when no declared subscription carries the id
5  -SubscriptionIdAssertIs         the optional guard: the session's id must equal the given one
6  wrong subscription              the throw when they differ: a mis-wired service connection
7  Get-AzureEnvironment            asserts that the session's subscription serves the environment
8  Get-BicepTemplateConfiguration  reads configuration/[<customer>/]<env>[-<slot>].yml
9  Get-BicepResourceGroupName      derives the resource-group name from the env, the slot and the customer

Supports ADR-AZ-DATAMOD#4, #5 and #7 (implementation lens).
```

`Get-BicepDeploymentContext` is where cats turns an az session into a deployment. It runs three stages in a fixed order: it reads the
session and resolves it against `azure.yml`, it applies the optional guard, and only then does it address the slot, with the session's
customer deciding which config file, which environment check and which resource-group name apply. Everything downstream reads the one
identity resolved here.

![Get-BicepDeploymentContext reads the session, guards it, then picks the slot](../../.assets/explanation/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.drawio.png)

The diagram is described element by element in
[its asset description](../../.assets/explanation/adr-az-datamod--read-the-session-guard-then-pick-slot--implementation.drawio.md).

## Walkthrough

1. **Get-CurrentAzSubscription.** Runs `az account show` and returns the session's active subscription as an object with its id, name and
   tenant. With no active context it throws and names `az login` and `az account set` as the remedy.
2. **Get-AzCliSessionSubscription.** The reverse lookup in `Catzc.Azure.Cli`. It calls `Get-CurrentAzSubscription`, finds the `azure.yml`
   subscription whose id matches, and returns `{ name, id, customer, tenant }` from `Get-AzureSubscription`. The `customer` is the canonical
   customer key, or the empty string for a non-customer subscription. `Get-BicepDeploymentContext` calls it first, before any guard or slot
   work.
3. **azure.yml.** The declared subscriptions, read through `Get-Config -Config azure`. The lookup compares the session's id with every
   declared subscription's `id`.
4. **Undeclared subscription.** When no declared subscription carries the session's id, the lookup throws, naming the session's
   subscription, the declared ones and `az account set`. An id declared more than once throws too, since subscription ids must be unique.
5. **-SubscriptionIdAssertIs.** When the parameter is set, it must be a GUID and must equal the resolved session's id. When it is unset, the
   check is skipped. The session's `name` and `customer` are then taken as the deploy's subscription and customer.
6. **Wrong subscription.** When the ids differ, the context throws: the session targets one subscription, the caller expected another, and
   in a pipeline that means the service connection is wired to the wrong subscription.
7. **Get-AzureEnvironment.** Called with the environment argument and the session's subscription name. It asserts that the subscription
   serves the environment and embeds the resolved subscription, customer included, into the environment descriptor. Just before it, the
   context checks that the template has a config for the (customer, env, slot) coordinate and throws with the coordinate otherwise.
8. **Get-BicepTemplateConfiguration.** Reads the slot's config file. With a customer it is `configuration/<customer>/<env>[-<slot>].yml`;
   without one it is the configuration-root file. The coordinate is the file address, with no resolution machinery.
9. **Get-BicepResourceGroupName.** For a ResourceGroup-target template, derives the resource-group name from the template, the environment,
   the slot and the session's customer through the namer. Nothing is hand-typed; a Subscription-target template leaves the resource group
   unset.

## Why it holds

- The customer is derived from the session subscription (`subscription.customer`), never a deploy argument: `Deploy-Bicep` has no
  `-Customer` parameter, and a customer-subscription session addresses the customer's subfolder config (ADR-AZ-DATAMOD#4).
- The resource-group name is derived by `Get-BicepResourceGroupName`, never hand-typed (ADR-AZ-DATAMOD#5).
- The joins resolve on demand in `Get-AzureEnvironment` and `Get-BicepDeploymentContext`; the deploy-time subscription is the az session's,
  reverse-resolved by `Get-AzCliSessionSubscription`, and `-SubscriptionIdAssertIs` is a guard, never a selector (ADR-AZ-DATAMOD#7).

## Where the code and the ADR differ

- The help text of `Get-BicepDeploymentContext` says a Subscription-target config lives at `configuration/<slot>.yml`; the code reads every
  config at `configuration/[<customer>/]<env>[-<slot>].yml`, as the ADR states.

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains.
- The other lenses on the same deploy target: [meta](the-session-is-the-deploy-target.md),
  [architecture](one-reverse-lookup-feeds-every-module.md), [operations](pipeline-pins-devbox-picks-the-target.md) and
  [governance](four-gates-hold-the-session-rule.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

# Four gates hold the session rule; the customer and the name hold by construction

```text
Four throwing gates hold ADR-AZ-DATAMOD#7; rules #4, #5 and ADR-AZ-NAMING#8 hold by construction, with no gate.

1  assert given in a pipeline  #7: Deploy-Bicep throws in a pipeline without -SubscriptionIdAssertIs
2  subscription declared       #7: Get-AzCliSessionSubscription throws on an id azure.yml does not declare
3  session matches the assert  #7: Get-BicepDeploymentContext throws when the session differs from the pin
4  customer from the session   #4: the customer is read off the session; Deploy-Bicep has no -Customer
5  serves the env              #7: Get-AzureEnvironment throws when the subscription does not serve the env
6  RG name derived             #5 and NAMING#8: Get-BicepResourceGroupName builds the name; no subscription in it
7  throw                       every gate ends here; nothing retargets or falls back

Supports ADR-AZ-DATAMOD#4, #5 and #7, and ADR-AZ-NAMING#8 (governance lens).
```

The rule that the az session is the deploy target has four parts, and cats holds each one behind a check that throws: a pipeline must give
the pin, the session must be declared, the session must match the pin, and the session's subscription must serve the environment. Two
neighbouring rules need no check at all. The customer comes from the session because the deploy has no way to say otherwise, and the
resource-group name is built by one function that never sees a subscription. No message or help text contradicts these rules; one help text
misstates a config path.

![Four gates hold the session rule; the customer and the name hold by construction](../.assets/adr-az-datamod--four-gates-hold-the-session-rule--governance.drawio.png)

The diagram is described element by element in [its asset description](four-gates-hold-the-session-rule.drawio.md).

## Walkthrough

1. **Assert given in a pipeline.** `Deploy-Bicep` checks, before resolving anything, that a pipeline run carries `-SubscriptionIdAssertIs`,
   and throws at the call site when it does not. On a devbox the check does not apply, so the pin stays optional there. The gate holds the
   "mandatory in a pipeline" half of ADR-AZ-DATAMOD#7.
2. **Subscription declared.** `Get-AzCliSessionSubscription` matches the session's subscription id against the subscriptions `azure.yml`
   declares and throws when none, or more than one, carries it. Config defines what is correct: an undeclared session is an error, never a
   fallback.
3. **Session matches the assert.** `Get-BicepDeploymentContext` compares the resolved session's id with the pin and throws on a mismatch,
   naming both subscriptions and the mis-wired service connection. The pin never changes the target; the gate only confirms it.
4. **Customer from the session.** The context reads the customer off the resolved session subscription. No gate checks that the customer was
   not passed in, because it cannot be: `Deploy-Bicep` and `Get-BicepDeploymentContext` have no `-Customer` parameter. ADR-AZ-DATAMOD#4
   holds by construction.
5. **Serves the env.** `Get-AzureEnvironment`, called with the session's subscription, asserts that the subscription's `environments` list
   contains the requested environment and throws otherwise. This is the check that a session cannot deploy an environment its subscription
   does not serve.
6. **RG name derived.** `Get-BicepResourceGroupName` builds the resource-group name from the template, the environment, the slot and the
   session's customer, through `Get-BicepResourceName` and the namer. No gate asserts that nobody typed the name or that the subscription
   stayed out of it: the function is the only source of the name, and it takes no subscription. ADR-AZ-DATAMOD#5 and ADR-AZ-NAMING#8 hold by
   construction.
7. **Throw.** Every gate ends in a throw that stops the deploy before a build artifact is read or `az deployment` is called. Nothing is
   retargeted, defaulted or repaired along the way.

## Why it holds

- The customer is derived from the session subscription at deploy time, never a deploy argument (ADR-AZ-DATAMOD#4).
- The resource-group name is derived by `Get-BicepResourceGroupName`, never hand-typed (ADR-AZ-DATAMOD#5).
- The deploy-time subscription is the az session's, reverse-resolved against `azure.yml`; `-SubscriptionIdAssertIs` is mandatory in a
  pipeline and optional on a devbox, and it is a guard, never a selector (ADR-AZ-DATAMOD#7).
- The subscription is a resolution axis only and never a name component (ADR-AZ-NAMING#8).

## Where the code and the ADR differ

- The help text of `Get-BicepDeploymentContext` says a Subscription-target config lives at `configuration/<slot>.yml`; the code reads every
  config at `configuration/[<customer>/]<env>[-<slot>].yml`, as the ADR states.
- The ADR names `Deploy-Bicep` as the function that throws without the pin, and so does the code; `Get-BicepDeploymentContext` on its own
  accepts a pipeline call without the pin, so the first gate guards the deploy surface, not the context function.

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains.
- [Azure resource naming standard](../../adr/azure/azure-naming-standard.md) — why the subscription never enters a name.
- The other lenses on the same deploy target: [meta](the-session-is-the-deploy-target.md),
  [architecture](one-reverse-lookup-feeds-every-module.md), [implementation](read-the-session-guard-then-pick-slot.md) and
  [operations](pipeline-pins-devbox-picks-the-target.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

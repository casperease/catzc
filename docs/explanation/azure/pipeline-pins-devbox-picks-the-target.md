---
catzc:
  immutable:
    with_body_sha: "52de04b4e6a0"
    repo_status: clean
    path: docs/explanation/azure/pipeline-pins-devbox-picks-the-target.md
    folder: docs/explanation/azure
    name: pipeline-pins-devbox-picks-the-target
    filetype: md
    kind: explanation
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AZ-DATAMOD#7
    links:
      - docs/adr/azure/azure-data-model.md
      - docs/explanation/.assets/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png
      - docs/explanation/azure/four-gates-hold-the-session-rule.md
      - docs/explanation/azure/index.md
      - docs/explanation/azure/one-reverse-lookup-feeds-every-module.md
      - docs/explanation/azure/pipeline-pins-devbox-picks-the-target.drawio.md
      - docs/explanation/azure/read-the-session-guard-then-pick-slot.md
      - docs/explanation/azure/the-session-is-the-deploy-target.md
      - docs/explanation/index.md#how-to-read-the-diagrams
---

# A pipeline pins the subscription it expects; a devbox picks the target with az account set

```text
A pipeline deploy pins its expected subscription; a devbox deploy picks the target with az account set.

1  service connection       the AzureCLI@2 login a pipeline deploy runs under
2  az account set           how a developer picks the session's subscription on a devbox
3  Deploy-Bicep             the one deploy command, with -SubscriptionIdAssertIs in a pipeline
4  deployment context       what a resolved deploy prints before it deploys: plan, artifacts and identity
5  no assert in a pipeline  the throw when a pipeline deploy omits -SubscriptionIdAssertIs
6  undeclared subscription  the throw when the session targets a subscription azure.yml does not declare
7  wrong subscription       the throw when the session differs from the pinned subscription id

Supports ADR-AZ-DATAMOD#7 (operations lens).
```

Nobody passes a subscription to a deploy in cats. A pipeline signs in through its service connection and states, with
`-SubscriptionIdAssertIs`, the subscription it expects that connection to have signed into; a developer sets the session with
`az account set` and runs the same command without the pin. Either way `Deploy-Bicep` resolves the session, prints the deployment context it
is about to act on, and stops with one of three errors when the session is missing a pin, undeclared, or not the one expected.

![A pipeline pins the subscription it expects; a devbox picks the target with az account set](../.assets/adr-az-datamod--pipeline-pins-devbox-picks-the-target--operations.drawio.png)

The diagram is described element by element in [its asset description](pipeline-pins-devbox-picks-the-target.drawio.md).

## Walkthrough

1. **Service connection.** A pipeline deploy step is an `AzureCLI@2` task whose `azureSubscription` names the service connection. The shared
   platform's `cd-shared.yaml` uses one connection per tier, and a customer pipeline such as `cd-nova.yaml` lists, per deploy entry, its
   `serviceConnection` and the matching `subscriptionIdAssertIs` from `azure.yml`.
2. **Az account set.** On a devbox the developer runs `az login` and `az account set` to pick the session's subscription. Cats never logs in
   or switches the session itself; the deploy only reads it.
3. **Deploy-Bicep.** The one deploy command. A pipeline runs it as
   `Deploy-Bicep -Environment nsub -Template foundation -SubscriptionIdAssertIs <guid> -ArtifactsFolder "$(Pipeline.Workspace)/foundation"`;
   a devbox runs `Deploy-Bicep -Environment dev -Template expedition`, with the pin optional and the build run locally. The customer is not
   an argument: it comes from the session's subscription.
4. **Deployment context.** When the session resolves and passes the guard, the command writes the `deployment context` it is about to use:
   the plan with the derived resource group, the build artifacts, and the environment with its subscription. It then runs the pre-deploy
   hook, ensures the resource group, and calls `az deployment … create` in the session's subscription. `-DryRun` previews with `--what-if`
   and stops there.
5. **No assert in a pipeline.** A pipeline deploy without the pin stops at the call site with
   `Deploy-Bicep requires -SubscriptionIdAssertIs in a pipeline …`, which goes on to say that the pipeline must pin the subscription GUID
   its service connection is expected to target. The fix is to add the pin to the pipeline's deploy entry.
6. **Undeclared subscription.** A session pointed at a subscription `azure.yml` does not declare stops with
   `The az session's subscription '<name>' (<id>) is not declared in azure.yml …`, which goes on to name `az account set` and the declared
   subscriptions. The fix is `az account set`, or a declaration in `azure.yml`.
7. **Wrong subscription.** A session that differs from the pin stops with
   `-SubscriptionIdAssertIs failed: the az session targets subscription '<name>' (<id>), not <guid> …`, which goes on to say that in a
   pipeline this means the service connection is wired to the wrong subscription. The fix is to re-wire the service connection, or to
   correct the pin; the deploy is never retargeted. A session whose customer has no config for the requested environment and slot stops as
   well, naming the coordinate and the configs the template does have.

## Why it holds

- The deploy-time subscription is the az session's, in a pipeline exactly what the service connection logged into, and a pipeline deploy
  must still pin its target: `-SubscriptionIdAssertIs` is mandatory in a pipeline, where `Deploy-Bicep` throws without it, and optional on a
  devbox (ADR-AZ-DATAMOD#7).
- The assert is a guard, never a selector: a mismatch means a mis-wired service connection and fails loudly (ADR-AZ-DATAMOD#7).

## Where the code and the ADR differ

- The help text of `Get-BicepDeploymentContext` says a Subscription-target config lives at `configuration/<slot>.yml`; the code reads every
  config at `configuration/[<customer>/]<env>[-<slot>].yml`, as the ADR states.

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains.
- The other lenses on the same deploy target: [meta](the-session-is-the-deploy-target.md),
  [architecture](one-reverse-lookup-feeds-every-module.md), [implementation](read-the-session-guard-then-pick-slot.md) and
  [governance](four-gates-hold-the-session-rule.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

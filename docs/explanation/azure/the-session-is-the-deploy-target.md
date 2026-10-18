# The az session is the deploy target, and the guard only checks it

```text
The deploy target is the az session's subscription; the guard checks it and never selects it.

1  az session            the az CLI's active subscription: what the service connection logged into
2  subscription guard    the pin of the expected subscription id; mandatory in a pipeline
3  deploy target         the confirmed subscription, whose customer picks the config and the names
4  mis-wired connection  the throw when the session and the pin disagree

Supports ADR-AZ-DATAMOD#7 (meta lens).
```

Cats deploys a Bicep template into whatever subscription the az session is signed in to. No deploy call, pipeline step or config path names
the subscription: in a pipeline it is exactly what the service connection logged into, and on a devbox it is what `az account set` chose. A
guard can state which subscription the session is expected to target, and in a pipeline it must, but the guard only confirms the target. It
never picks one.

![The az session is the deploy target, and the guard only checks it](../.assets/adr-az-datamod--the-session-is-the-deploy-target--meta.drawio.png)

The diagram is described element by element in [its asset description](the-session-is-the-deploy-target.drawio.md).

## Walkthrough

1. **Az session.** The az CLI's active subscription. In a pipeline it is the subscription the service connection logged into; on a devbox
   `az login` and `az account set` choose it. Cats reads the session and resolves its subscription id against `azure.yml`. A session that
   targets a subscription the file does not declare is an error, not a fallback.
2. **Subscription guard.** `-SubscriptionIdAssertIs` carries the subscription id the session is expected to target. It is mandatory in a
   pipeline, where `Deploy-Bicep` throws without it, and optional on a devbox. When it is set, the resolved session must carry the same id.
   The guard selects nothing: the session has already decided.
3. **Deploy target.** The session's subscription, confirmed. Its `customer` picks the template's configuration slot, the customer's
   subfolder or the configuration root, and renders into the resource-group name. The subscription itself never appears in a name.
4. **Mis-wired connection.** When the session's id and the guard's id differ, the deploy throws before anything is built or deployed. In a
   pipeline that means the service connection is wired to the wrong subscription, so a re-wired connection can never silently retarget an
   existing pipeline's deploy.

## Why it holds

- The deploy-time subscription is determined by the az session, reverse-resolved against `azure.yml`, and a pipeline deploy must still pin
  its target: `-SubscriptionIdAssertIs` is mandatory in a pipeline and optional on a devbox (ADR-AZ-DATAMOD#7).
- The assert is a guard, never a selector: a mismatch means a mis-wired service connection and fails loudly (ADR-AZ-DATAMOD#7).

## See also

- [Templating data model](../../adr/azure/azure-data-model.md) — the decision this article explains.
- The other lenses on the same deploy target: [architecture](one-reverse-lookup-feeds-every-module.md),
  [implementation](read-the-session-guard-then-pick-slot.md), [operations](pipeline-pins-devbox-picks-the-target.md) and
  [governance](four-gates-hold-the-session-rule.md).
- [The azure explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

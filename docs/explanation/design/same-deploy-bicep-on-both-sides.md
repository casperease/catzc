# A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription

```text
A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription.

1  Connect-AzCli                  a developer's first step: log az in
2  Mode: azcli                    a pipeline's step: AzureCLI@2 with a service connection
3  Deploy-Bicep                   the one command both sides type
4  subscription target rejected   the throw when the target is unpinned, mismatched or undeclared
5  what-if preview                the -DryRun outcome: a preview, nothing deployed
6  ... failed (az exited N)       the throw when az exits non-zero
7  Deployment ... succeeded       the outcome when the guards pass and az succeeds

Supports DDR-THINPLAT-DELEGATENOTREIMPLEMENT and DDR-THINPLAT-PLATFORMASCLI (operations lens).
```

`Deploy-Bicep` is the one command a developer and a CD pipeline both type to deploy infrastructure, because the CLI is the platform's only
surface. The one thing a pipeline must add is `-SubscriptionIdAssertIs`, the subscription it expects the az session to target. Without it,
or when it does not match the az session, the run stops before az deploys anything. From there the run ends in one of four ways: a preview,
a deployment, or one of two failures.

```yml drawio
description:
  A developer after Connect-AzCli and a pipeline step in azcli mode type the same Deploy-Bicep; only the pipeline must pin the subscription,
  and a run ends as a rejection, a preview, a failure or a deployment.
about:
  adrs: [DDR-THINPLAT-DELEGATENOTREIMPLEMENT, DDR-THINPLAT-PLATFORMASCLI]
  lens: operations
content:
  title: A developer and a pipeline type the same Deploy-Bicep; only the pipeline must pin the subscription
  kind: explanation
  flow: top-to-bottom
  theme: dark
  bands:
    - { id: band-consumers, label: CONSUMERS }
    - { id: band-surface, label: CLI SURFACE }
    - { id: band-catzc, label: CATZC }
    - { id: band-delegated, label: DELEGATED }
    - { id: band-substrate, label: VENDOR SUBSTRATE }
  glyphs:
    - { id: g-connect, kind: code, label: Connect-AzCli, in: band-consumers }
    - { id: g-mode, kind: runner, label: "Mode: azcli", in: band-consumers }
    - { id: g-deploy, kind: code, label: Deploy-Bicep, in: band-surface }
    - { id: f-rejected, kind: failure, label: subscription target rejected, in: band-catzc }
    - { id: r-preview, kind: result, label: what-if preview, in: band-delegated }
    - { id: f-failed, kind: failure, label: "... failed (az exited N)", in: band-delegated }
    - { id: r-succeeded, kind: result, label: Deployment ... succeeded, in: band-substrate }
  edges:
    - { from: g-connect, to: g-deploy, kind: flow, label: calls }
    - { from: g-mode, to: g-deploy, kind: flow, label: calls }
    - { from: g-deploy, to: f-rejected, kind: fail, label: "" }
    - { from: g-deploy, to: r-preview, kind: flow, label: "" }
    - { from: g-deploy, to: f-failed, kind: fail, label: "" }
    - { from: g-deploy, to: r-succeeded, kind: flow, label: "" }
  markers:
    - { at: g-connect, number: 1 }
    - { at: g-mode, number: 2 }
    - { at: g-deploy, number: 3 }
    - { at: f-rejected, number: 4 }
    - { at: r-preview, number: 5 }
    - { at: f-failed, number: 6 }
    - { at: r-succeeded, number: 7 }
  legend: auto
  minimaps: [code-locations, module-neighbourhood, axis]
layout:
  band-consumers: { x: 20, y: 84, w: 1260, h: 100 }
  band-surface: { x: 20, y: 204, w: 1260, h: 100 }
  band-catzc: { x: 20, y: 324, w: 1260, h: 100 }
  band-delegated: { x: 20, y: 444, w: 1260, h: 100 }
  band-substrate: { x: 20, y: 564, w: 1260, h: 100 }
  g-connect: { x: 270, y: 120, w: 260, h: 44 }
  g-mode: { x: 780, y: 120, w: 260, h: 44 }
  g-deploy: { x: 460, y: 240, w: 360, h: 44 }
  f-rejected: { x: 900, y: 360, w: 280, h: 44 }
  r-preview: { x: 200, y: 480, w: 260, h: 44 }
  f-failed: { x: 700, y: 480, w: 260, h: 44 }
  r-succeeded: { x: 520, y: 600, w: 260, h: 44 }
```

![A developer and a pipeline run the same Deploy-Bicep](.assets/same-deploy-bicep-on-both-sides.drawio.png)

## Walkthrough

1. **Connect-AzCli.** A developer's first step: it logs az in, and then the developer types `Deploy-Bicep dev sample` (or adds `-DryRun`).
   Without a login, the session lookup stops the run and asks for `az login`.
2. **Mode: azcli.** A pipeline's step: `invoke-automation.yaml` with `Mode: azcli`, a `ServiceConnection` and a `RunCommand`. All six
   `Deploy-Bicep` steps in `cd-shared.yaml` run this way, and each passes `-ArtifactsFolder` and `-SubscriptionIdAssertIs <guid>`.
3. **Deploy-Bicep.** The one command: `Deploy-Bicep <env> <template> [-DryRun] [-SubscriptionIdAssertIs <guid>]`. A devbox builds the
   template on the fly, or reuses the last build with `-DoNotRebuild`; a pipeline deploys the downloaded artifacts, and throws at once on
   `-DoNotRebuild`, `-OverrideDoNotRunAndRun`, or a missing `-ArtifactsFolder`. A template marked DoNotRun prints
   `Skipping deployment for '<template>' (<env>) — DoNotRun` and returns.
4. **Subscription target rejected.** The guard on the target, raised by three functions. `Deploy-Bicep` throws when a pipeline calls it
   without `-SubscriptionIdAssertIs` ("Deploy-Bicep requires -SubscriptionIdAssertIs in a pipeline"). `Get-BicepDeploymentContext` throws
   when the parameter differs from the az session ("-SubscriptionIdAssertIs failed: the az session targets subscription …").
   `Get-AzCliSessionSubscription` throws when the session's subscription is not declared ("The az session's subscription … is not declared
   in azure.yml").
5. **What-if preview.** Under `-DryRun` the command runs `az … --what-if` as a preview and stops; nothing is deployed and no tags are set.
6. **Failed (az exited N).** When az exits non-zero, the run throws `Deployment '<name>' failed (az exited N)`, or
   `What-if preview for '<name>' failed (az exited N)` for a preview, with the az command, its stderr and its stdout.
7. **Deployment succeeded.** When the guards pass and az exits 0, the command checks that the deployment's `provisioningState` is
   `Succeeded` (it throws otherwise), prints `Deployment '<name>' succeeded`, and sets the tracking tags.

## Why it holds

- Thin comes from delegation: the command checks the target and hands the deployment to az (DDR-THINPLAT-DELEGATENOTREIMPLEMENT).
- The CLI is the only surface, so a developer and a pipeline bind to the same `Deploy-Bicep` (DDR-THINPLAT-PLATFORMASCLI).

## Where the code and the decision record differ

ADR-AUTO-PARITY-ONESEAM allows a command to branch on the pipeline seam only where the environments genuinely differ, and names where output
goes and the dev-box auto-commit. Here the seam also changes what the command does: `-SubscriptionIdAssertIs` is mandatory only in a
pipeline, a devbox builds where a pipeline needs artifacts, `-DoNotRebuild` and `-OverrideDoNotRunAndRun` work on a devbox only, and the
`az_cli` pin is relaxed off a pipeline, where an installed az matching `devbox_version` is also accepted.

## See also

- [Thin platforms](../../drs/design/thin-platforms.md) — the decision this article explains.
- [Devbox / pipeline parity](../../drs/automation/devbox-pipeline-parity.md) — the one seam between a devbox and a pipeline.
- The other lenses on the same platform: [meta](bind-to-one-cli-delegate-the-rest.md),
  [architecture](every-vendor-call-leaves-through-az.md), [implementation](deploy-bicep-delegates-to-az.md) and
  [governance](what-keeps-the-platform-thin.md).
- [The design explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

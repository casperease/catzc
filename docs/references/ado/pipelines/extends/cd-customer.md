# .ado/pipelines/extends/cd-customer.yaml

The one shared structure of every customer CD. It is a whole-pipeline template that the thin root pipelines (`cd-apex.yaml`,
`cd-nova.yaml`, `cd-flux.yaml`) `extends:`, and it is the sanctioned large-template case of
[ADR-ADO-NAME](../../../../drs/ado/pipeline-naming-and-placement.md): a root supplies only selection criteria, and no automation config is
needled through ([ADR-ADO-TEMPLATE](../../../../drs/ado/custom-template-discipline.md)).

## Parameters

- **`Customer`** — the customer key. It is also the folder name, so the build needs no subscription names.
- **`Foundations`** and **`Discoveries`** — per-subscription templates: one entry per per-subscription env (`nsub`, `psub`), the same
  coordinates in both lists.
- **`Expeditions`** — slotted: one entry per `<env>[-<slot>]` config, where an entry without `slot` is the env's configuration without a slot name. An empty list
  means the customer has no expedition config.

Each list names exactly the configs the template has for this customer, and `${{ each }}` renders one deployment job per entry. An entry
carries its own `serviceConnection` (the nonprod subscription serves `nsub`, `dev` and `test`; the prod subscription serves `psub`,
`preprod` and `prod`) and the matching `subscriptionIdAssertIs` GUID from `azure.yml`. These are reference shapes: real service connections
and a non-placeholder `azure.yml` are needed to deploy.

## The deploy target

The target is the az session's subscription, exactly what each entry's service connection logs into
([ADR-AZ-DATAMOD](../../../../drs/azure/azure-data-model.md)). Nothing chains a subscription name; instead every entry pins its expectation
with `subscriptionIdAssertIs`, mandatory in a pipeline, so a mis-wired service connection fails loudly instead of silently retargeting. The
customer the templates render into names is derived from the session subscription, and the session's customer picks the
`configuration/<customer>/` folder.

## Stages

- **CI** — CD is CI plus deploy. The CI stage checks out with `fetchDepth: 0`, because `Test-GlobSetAffected` diffs real refs
  ([FDR-CD-GLOBS-CHANGECOMPUTEDFROMGIT](../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-changecomputedfromgit)), then publishes the
  step output `AFFECTED`. It builds only this customer's configuration subfolder with `Build-Bicep <tier> -Customers <Customer>` (build
  once) and publishes the artifacts. Because the customer key is the folder, the build tolerates an absent tier.
- **Expedition build** — a customer with no expedition config passes an empty list: `Build-Bicep` throws when no configuration matches, so the
  build, its artifact and its deploy stage are skipped.
- **Deploy** — `stages/deploy-unit.yaml` applies the artifacts in dependency order, foundation then discovery then expedition. Foundation
  owns the per-subscription Key Vault that discovery and expedition reference, so it deploys first; discovery is the landing zone, the
  customer's spoke, that expedition lands in, so it deploys second. The first deploy stage is skipped when the customer's unit is
  untouched, and the later ones chain on it.

## Boundaries

- One customer pipeline deploys one customer's spokes; the shared hubs deploy from `cd-shared.yaml`. The rollout order across them when a
  spoke is added (hub, then spoke, then hub again,
  [ADR-AZ-LZ-LINKSNEEDBOTHNETWORKS](../../../../drs/azure/landing-zones.md#rule-adr-az-lz-linksneedbothnetworks)) is run by hand across the
  two pipelines and not encoded here.
- Triggers live in the root pipelines, since `trigger:` and `pr:` are honoured only at the pipeline root, never inside an extended
  template.

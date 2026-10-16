---
catzc:
  derived:
    path: docs/references/pipelines/extends/cd-customer.yaml.md
    folder: docs/references/pipelines/extends
    name: cd-customer-yaml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: db19b4249f72
    adrs:
      - ADR-AZ-LZ#7
---

# pipelines/extends/cd-customer.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `parameters:`, written with `#`.

```text
Whole-pipeline (extends) template — the ONE shared structure for every customer CD.

Per [ADR-PIPE-NAME](/docs/adr/pipelines/pipeline-naming-and-placement.md), customer CD is the sanctioned large-template
case: every customer's thin pipeline (cd-apex.yaml, cd-nova.yaml, cd-flux.yaml) `extends:` this file
and supplies only meta selection criteria — the customer key and the per-deployment env/slot/
service-connection/assert map. No automation config is needled through
([ADR-PIPE-TEMPLATE](/docs/adr/pipelines/custom-template-discipline.md)).

The deploy TARGET is the az session's subscription — exactly what each entry's service connection logs
into ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)). Nothing chains a subscription name; instead every entry pins its
expectation with `subscriptionIdAssertIs` (mandatory in a pipeline), so a mis-wired service connection
fails loudly instead of silently retargeting. The customer that renders into names is derived from the
session subscription, and the session's customer picks the configuration/<customer>/ slot.

CD = CI + CD: the CI stage builds + publishes the immutable artifacts (filtered to this customer's
configuration subfolder via -Customers), then the deploy stages apply them in dependency order —
foundation -> discovery -> expedition. foundation owns the per-subscription Key Vault that
discovery/expedition reference, so it deploys first (dependsOn); discovery is the landing zone
(the customer's spoke) that expedition lands in, so it deploys second.

The three flat lists render cleanly with ${{ each }} — one deployment job per entry, and each list
names exactly the configs the template has for this customer. foundation and discovery are
per-subscription templates: one entry per per-subscription env (nsub, psub), the same coordinates.
expedition is slotted: one entry per <env>[-<slot>] config, where an entry without `slot` is the
env's base slot. Each entry carries its own serviceConnection (tier -> SC: the nonprod sub serves
nsub/dev/test, the prod sub serves psub/preprod/prod) plus the matching subscriptionIdAssertIs GUID
from azure.yml. Reference shapes only: real service connections + a non-placeholder azure.yml are
required to actually deploy.

One customer pipeline deploys one customer's spokes; the shared hubs deploy from cd-shared.yaml. The
rollout order across them when a spoke is added (hub, then spoke, then hub again —
[ADR-AZ-LZ#7](/docs/adr/azure/landing-zones.md#rule-adr-az-lz7)) is run by hand across the two pipelines, not encoded here.

Triggers live in the thin root pipelines that extend this template — `trigger:` / `pr:` are honored
only at the pipeline root, not inside an extends template.
```

## comment:2

Above `- template: /pipelines/steps/invoke-automation.yaml`, written with `#`.

```text
Build only this customer's configuration subfolder (build-once). The customer key IS the
folder, so -Customers needs no subscription names and tolerates an absent tier.
```

## comment:3

Above `- ${{ if gt(length(parameters.Expeditions), 0) }}:`, written with `#`.

```text
A customer without an expedition config passes an empty Expeditions list: Build-Bicep
throws when no slot matches, so the build, its artifact, and its deploy stage are skipped.
```

## comment:4

Above `- ${{ if gt(length(parameters.Expeditions), 0) }}:` (occurrence 2), written with `#`.

```text
--- Deploy expedition (slotted; lands in the discovery spoke) — after discovery, main only -----
An entry with a slot deploys the special slot <env>-<slot>; an entry without one the env's base
slot <env>. The ADO environment and the job name follow the config name. An empty Expeditions
list inserts no stage (a stage needs at least one job).
```

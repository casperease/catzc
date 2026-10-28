# .ado/pipelines/cd-flux.yaml

The CD pipeline of the customer flux: a thin root that picks what to deploy and hands everything else to the shared customer template
`extends/cd-customer.yaml`.

## What it supplies

- **Customer key** — `flux`.
- **Foundations and Discoveries** — the flux spoke at `nsub`, the nonprod tier only.
- **Expeditions** — an empty list. Flux has no expedition config, so `Deploy_Expedition` runs no job.
- **Per deployment** — the service connection and the `subscriptionIdAssertIs` GUID (from `azure.yml`) that pins the target subscription.

The prod tier (`psub`, preprod, `prod`) is added when flux grows. Each entry names the landing-zone service connection
`Get-BicepServiceConnections` derives for flux's non-prod subscription.

## Why it is shaped so

- **Structure lives in the template.** The CI build and the stage ordering are in the extended template.
- **Triggers live here.** ADO honours `trigger:` and `pr:` only at the pipeline root.
- **Path filters match the configs flux has.** The include list covers the shared templates and modules and flux's foundation and discovery
  configuration subfolders only, since there is no expedition config; the exclude list drops the other deployments' configuration
  ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).

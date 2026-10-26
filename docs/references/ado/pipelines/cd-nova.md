# .ado/pipelines/cd-nova.yaml

The CD pipeline of the customer nova: a thin root that picks what to deploy and hands everything else to the shared customer template
`extends/cd-customer.yaml`.

## What it supplies

- **Customer key** — `nova`.
- **Foundations and Discoveries** — the nova spoke at `nsub`, the nonprod tier only.
- **Expeditions** — `dev`, the configuration without a slot name, with its ADO environment.
- **Per deployment** — the service connection and the `subscriptionIdAssertIs` GUID (from `azure.yml`) that pins the target subscription.

The prod tier (`psub`, preprod, `prod`) is added when nova grows. The connection name `sc-nova-nonprod` is illustrative until real service
connections and a non-placeholder `azure.yml` exist.

## Why it is shaped so

- **Structure lives in the template.** The CI build and the stage ordering are in the extended template.
- **Triggers live here.** ADO honours `trigger:` and `pr:` only at the pipeline root.
- **Path filters are by configuration subfolder.** Only nova's own configuration subfolders are included and the other deployments'
  configuration is excluded, so their changes never trigger nova ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).

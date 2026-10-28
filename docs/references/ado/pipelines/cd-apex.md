# .ado/pipelines/cd-apex.yaml

The CD pipeline of the customer apex: a thin root that picks what to deploy and hands everything else to the shared customer template
`extends/cd-customer.yaml`.

## What it supplies

- **Customer key** — `apex`.
- **Foundations and Discoveries** — the apex spoke at `nsub`.
- **Expeditions** — `dev` (with its ADO environment) and the named configuration slot `blu` of `dev`.
- **Per deployment** — the service connection the run logs in with and the `subscriptionIdAssertIs` GUID (from `azure.yml`) that pins the
  target subscription, so a connection pointing at the wrong subscription fails the run.

The lists name apex's non-prod configs only: CD stays in non-prod
([FDR-CD-CDSTAYSINNONPROD](../../../drs/flow/cd-discipline-and-promotion-flow.md#rule-fdr-cd-cdstaysinnonprod)), and the prod subscription's
targets (`psub`, `preprod`, `prod`) are `deploy-apex.yaml`'s, as a pipeline test checks. Each entry names the service connection
`Get-BicepServiceConnections` derives for its subscription: the landing-zone identity's for foundation and discovery, the workload
identity's for expedition, as a pipeline test checks.

## Why it is shaped so

- **Structure lives in the template.** The CI build and the foundation, discovery, expedition ordering are in the extended template, so a
  customer root stays a list of selection criteria.
- **Triggers live here.** ADO honours `trigger:` and `pr:` only at the pipeline root, never in an extended template.
- **Path filters are by configuration subfolder.** The include list takes the shared templates and modules plus apex's own configuration
  subfolders; the exclude list drops the shared root configuration and every customer subfolder. The deeper apex include sits under that
  broader exclude, so ADO keeps it in the trigger. Other deployments' changes never trigger apex
  ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).

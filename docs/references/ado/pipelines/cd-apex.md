# .ado/pipelines/cd-apex.yaml

The CD pipeline of the customer apex: a thin root that picks what to deploy and hands everything else to the shared customer template
`extends/cd-customer.yaml`.

## What it supplies

- **Customer key** — `apex`.
- **Foundations and Discoveries** — the apex spoke at `nsub` and `psub`.
- **Expeditions** — `dev` (with its ADO environment), the named configuration slot `blu` of `dev`, and `prod`.
- **Per deployment** — the service connection the run logs in with and the `subscriptionIdAssertIs` GUID (from `azure.yml`) that pins the
  target subscription, so a connection pointing at the wrong subscription fails the run.

The lists name exactly the configs apex has: apex has both tiers, nonprod and prod. The service connection names (`sc-apex-*`) are
illustrative until real service connections and a non-placeholder `azure.yml` exist.

## Why it is shaped so

- **Structure lives in the template.** The CI build and the foundation, discovery, expedition ordering are in the extended template, so a
  customer root stays a list of selection criteria.
- **Triggers live here.** ADO honours `trigger:` and `pr:` only at the pipeline root, never in an extended template.
- **Path filters are by configuration subfolder.** The include list takes the shared templates and modules plus apex's own configuration
  subfolders; the exclude list drops the shared root configuration and every customer subfolder. The deeper apex include sits under that
  broader exclude, so ADO keeps it in the trigger. Other deployments' changes never trigger apex
  ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).

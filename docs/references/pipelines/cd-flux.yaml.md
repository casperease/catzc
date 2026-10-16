---
catzc:
  immutable:
    with_body_sha: a0457d45a845
    repo_status: locked
    path: docs/references/pipelines/cd-flux.yaml.md
    folder: docs/references/pipelines
    name: cd-flux-yaml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# pipelines/cd-flux.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
CD pipeline for customer flux — thin root that extends the shared customer CD template.

flux is dev-only (nonprod tier only), and the lists name exactly flux's configs: foundation and
discovery (the flux spoke) at nsub. flux has no expedition config, so its Expeditions list is empty
and Deploy_Expedition runs no job. Add the prod tier (psub / preprod / prod) when flux grows. All structure
lives in /pipelines/extends/cd-customer.yaml; triggers live here (honored only at the pipeline root).
The target subscription is what the service connection logs into; the subscriptionIdAssertIs GUID
(from azure.yml) pins it.

Reference shape: 'sc-flux-nonprod' is illustrative until real service connections + a non-placeholder
azure.yml exist.
```

## comment:2

Above `trigger:`, written with `#`.

```text
Flux has no expedition config, so its own include covers only foundation and discovery; other deployments' config is excluded.
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) [comment:2](/docs/references/pipelines/cd-flux.yaml.md#comment2)
```

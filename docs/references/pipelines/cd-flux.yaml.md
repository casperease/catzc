# docs/references/pipelines/cd-flux.yaml.md

`pipelines/cd-flux.yaml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

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

Above `trigger:`.

```text
Trigger = the 'flux' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)):
the foundation, discovery, and expedition templates + modules, plus flux's own configuration subfolder of
foundation and discovery (flux has no expedition config), minus the other deployments' config.
```

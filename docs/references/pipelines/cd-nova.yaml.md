# docs/references/pipelines/cd-nova.yaml.md

`pipelines/cd-nova.yaml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CD pipeline for customer nova — thin root that extends the shared customer CD template.

nova is dev-only (nonprod tier only), and the lists name exactly nova's configs: foundation and
discovery (the nova spoke) at nsub, expedition at dev (its base slot). Add the prod tier (psub /
preprod / prod) when nova grows. All structure
lives in /pipelines/extends/cd-customer.yaml; triggers live here (honored only at the pipeline root).
The target subscription is what the service connection logs into; the subscriptionIdAssertIs GUID
(from azure.yml) pins it.

Reference shape: 'sc-nova-nonprod' is illustrative until real service connections + a non-placeholder
azure.yml exist.
```

## comment:2

Above `trigger:`.

```text
Trigger = the 'nova' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)):
the foundation, discovery, and expedition templates + modules, plus nova's own configuration subfolder of
each, minus the other deployments' config.
```

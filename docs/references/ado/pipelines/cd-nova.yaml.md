# .ado/pipelines/cd-nova.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
CD pipeline for customer nova — thin root that extends the shared customer CD template.

nova is dev-only (nonprod tier only), and the lists name exactly nova's configs: foundation and
discovery (the nova spoke) at nsub, expedition at dev (its base slot). Add the prod tier (psub /
preprod / prod) when nova grows. All structure
lives in /.ado/pipelines/extends/cd-customer.yaml; triggers live here (honored only at the pipeline root).
The target subscription is what the service connection logs into; the subscriptionIdAssertIs GUID
(from azure.yml) pins it.

Reference shape: 'sc-nova-nonprod' is illustrative until real service connections + a non-placeholder
azure.yml exist.
```

## comment:2

Above `trigger:`, written with `#`.

```text
Only nova's own configuration subfolders are included and other deployments' config is excluded, so their changes never trigger it.
[FDR-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) [comment:2](/docs/references/ado/pipelines/cd-nova.yaml.md#comment2)
```

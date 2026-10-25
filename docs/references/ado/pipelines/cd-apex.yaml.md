# .ado/pipelines/cd-apex.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
CD pipeline for customer apex — thin root that extends the shared customer CD template.

Supplies only meta selection criteria: the customer key and the per-deployment env/slot/service-
connection/assert map. All structure (CI build, foundation -> discovery -> expedition ordering) lives
in /.ado/pipelines/extends/cd-customer.yaml. apex has both tiers, and the lists name exactly apex's configs:
foundation and discovery (the apex spoke) at nsub and psub; expedition at dev, the special slot
dev-blu, and prod. The target subscription is what each service connection logs into; the
subscriptionIdAssertIs GUID (from azure.yml) pins it. Triggers live here because they are honored
only at the pipeline root.

Reference shape: 'sc-apex-*' are illustrative until real service connections + a non-placeholder
azure.yml exist.
```

## comment:2

Above `trigger:`, written with `#`.

```text
The deeper apex include sits under the broader exclude of other deployments' config, so ADO keeps it in the trigger.
[FDR-CD-GLOBS](/docs/drs/flow/durable-sha-globs.md) [comment:2](/docs/references/ado/pipelines/cd-apex.yaml.md#comment2)
```

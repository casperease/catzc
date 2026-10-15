---
catzc:
  derived:
    path: docs/references/pipelines/cd-apex.yaml.md
    kind: reference
    body_sha: "8354a8c8e73a"
    adrs: []
---

# pipelines/cd-apex.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CD pipeline for customer apex — thin root that extends the shared customer CD template.

Supplies only meta selection criteria: the customer key and the per-deployment env/slot/service-
connection/assert map. All structure (CI build, foundation -> discovery -> expedition ordering) lives
in /pipelines/extends/cd-customer.yaml. apex has both tiers, and the lists name exactly apex's configs:
foundation and discovery (the apex spoke) at nsub and psub; expedition at dev, the special slot
dev-blu, and prod. The target subscription is what each service connection logs into; the
subscriptionIdAssertIs GUID (from azure.yml) pins it. Triggers live here because they are honored
only at the pipeline root.

Reference shape: 'sc-apex-*' are illustrative until real service connections + a non-placeholder
azure.yml exist.
```

## comment:2

Above `trigger:`.

```text
Trigger = the 'apex' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)):
the foundation, discovery, and expedition templates + modules, plus apex's own configuration subfolder of
each, minus the other deployments' config. A deeper-folder include (configuration/apex/**) over the broader
exclude, so ADO keeps it.
```

---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/options.yml.md
    kind: comment-page
    body_sha: "18f2660fa767"
---

# infrastructure/templates/expedition/options.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `short_name: exped`.

```text
Per-template options for 'expedition' — the Well-Architected workload: storage and a SQL database behind
private endpoints, landing in a discovery network. Deployed into its own resource group, one per
configuration slot.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: standard  -> configs use the standard envs (dev/test/preprod/prod), slotted per config
```

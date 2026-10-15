---
catzc:
  derived:
    path: docs/references/infrastructure/templates/foundation/options.yml.md
    kind: comment-page
    body_sha: "34a747daa829"
    adrs: []
---

# infrastructure/templates/foundation/options.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `short_name: fnd`.

```text
Per-template options for 'foundation' — the once-per-subscription baseline (Log Analytics + Key
Vault). Its Key Vault holds the SQL admin password that consuming templates reference.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: subscription  -> configs use per-subscription envs (nsub/psub), once per sub
(Slot is per-config, not a template bit — foundation's configs simply carry no slot.)
```

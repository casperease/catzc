---
catzc:
  derived:
    path: docs/references/infrastructure/templates/expedition/options.yml.md
    folder: docs/references/infrastructure/templates/expedition
    name: options-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: eb80f2153485
---

# infrastructure/templates/expedition/options.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `short_name: exped`, written with `#`.

```text
Per-template options for 'expedition' — the Well-Architected workload: storage and a SQL database behind
private endpoints, landing in a discovery network. Deployed into its own resource group, one per
configuration slot.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: standard  -> configs use the standard envs (dev/test/preprod/prod), slotted per config
```

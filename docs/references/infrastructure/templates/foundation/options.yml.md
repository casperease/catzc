---
catzc:
  derived:
    path: docs/references/infrastructure/templates/foundation/options.yml.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: a8739bf864a8
---

# infrastructure/templates/foundation/options.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `short_name: fnd`, written with `#`.

```text
Per-template options for 'foundation' — the once-per-subscription baseline (Log Analytics + Key
Vault). Its Key Vault holds the SQL admin password that consuming templates reference.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: subscription  -> configs use per-subscription envs (nsub/psub), once per sub
(Slot is per-config, not a template bit — foundation's configs simply carry no slot.)
```

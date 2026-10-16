---
catzc:
  immutable:
    with_body_sha: "51994793db3c"
    path: docs/references/infrastructure/templates/discovery/options.yml.md
    folder: docs/references/infrastructure/templates/discovery
    name: options-yml
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# infrastructure/templates/discovery/options.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `short_name: disco`, written with `#`.

```text
Per-template options for 'discovery' — the CAF application landing zone: the hub-and-spoke network, the
policy assignments, the activity log, and the budget of one subscription. Deployed at subscription scope.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: subscription  -> configs use per-subscription envs (nsub/psub), once per subscription
  deployment_target: Subscription -> az deployment sub create; the template creates its own resource group
```

# docs/references/infrastructure/templates/discovery/options.yml.md

`infrastructure/templates/discovery/options.yml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `short_name: disco`.

```text
Per-template options for 'discovery' — the CAF application landing zone: the hub-and-spoke network, the
policy assignments, the activity log, and the budget of one subscription. Deployed at subscription scope.

Classification ([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)):
  environment_kind: subscription  -> configs use per-subscription envs (nsub/psub), once per subscription
  deployment_target: Subscription -> az deployment sub create; the template creates its own resource group
```

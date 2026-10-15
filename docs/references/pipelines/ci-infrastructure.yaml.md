# docs/references/pipelines/ci-infrastructure.yaml.md

`pipelines/ci-infrastructure.yaml`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `trigger:`.

```text
CI pipeline for the infrastructure templates (foundation / discovery / expedition).

CI = the CI engine alone: build + verify, no artifact, no deploy (see
[ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md)). For each template it runs Assert-BicepTemplate (the explicit
author/CI-facing validation: options.yml schema, env-class + slot classification, identity refs,
parameter alignment) and then Build-Bicep (compile main.bicep + render every per-slot parameter file +
run the UNDEFINED gate). Finally it runs the infrastructure globset's test suite (Test-Automation -Suite infrastructure).
Building needs no auth — `az bicep build` is offline — so Mode stays 'none'.

One pipeline covers all three templates; it is fast enough to stay inside the 5-10 min pre-commit
budget. Revisit per-template CI only if build time grows.

The CI engine runs in two trigger contexts on the same code:
  - pre-commit  : as an ADO build validation on PRs to main (the gate)
  - post-commit : the same build + verify on the merged commit
Trigger = the 'infrastructure' globset projected into ADO-native path filters (Get-GlobSetTrigger,
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)): the track is its own root folder (infrastructure/**), so this starts only on a
real change.
```

## comment:2

Above `- template: /pipelines/steps/invoke-automation.yaml`.

```text
The infrastructure globset's test suite: its verify scope (Catzc.Azure.Templates up to L2,
[ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)), including the L2 test that
builds every shipped template and checks its rendered parameters files against the compiled parameter model
([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)).
```

# pipelines/ci-infrastructure.yaml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `trigger:`, written with `#`.

```text
Build and verify only, no artifact and no deploy; az bicep build is offline, so Mode stays none and no auth is needed.
[ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md),
[ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md) [comment:1](/docs/references/pipelines/ci-infrastructure.yaml.md#comment1)
```

## comment:2

Above `- template: /pipelines/steps/invoke-automation.yaml` (occurrence 7), written with `#`.

```text
The infrastructure globset's test suite: its verify scope (Catzc.Azure.Templates up to L2,
[ADR-AUTO-TEST#37](/docs/adr/automation/test-automation.md#rule-adr-auto-test37)), including the L2 test that
builds every shipped template and checks its rendered parameters files against the compiled parameter model
([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)).
```

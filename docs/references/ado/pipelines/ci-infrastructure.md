# .ado/pipelines/ci-infrastructure.yaml

The CI pipeline of the infrastructure tree: it validates and builds the foundation, discovery and expedition templates and runs the
infrastructure test suite. It builds and verifies only, with no artifact and no deploy ([FDR-TYPE](../../../drs/flow/pipeline-types.md)).

## Behaviour

- **Triggers** — any change under `infrastructure/**` on `main` or in a pull request, except the README files of the tree
  ([FDR-GLOBS](../../../drs/flow/durable-sha-globs.md)).
- **No auth** — `bicep build` is offline, so no mode is set and the pipeline needs no service connection.
- **Per tier** — `Assert-BicepTemplate <tier>` then `Build-Bicep <tier>` (compile, render and verify) for foundation, discovery and
  expedition.
- **Suite** — `Test-Automation -Suite infrastructure` closes the job. The infrastructure globset's test suite is what it verifies:
  `Catzc.Azure.Templates` up to L2 ([ADR-AUTO-TEST-TESTSUITE](../../../drs/automation/test-automation.md#rule-adr-auto-test-testsuite)). The
  L2 test builds every shipped template and checks its rendered parameters files against the compiled parameter model
  ([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)).

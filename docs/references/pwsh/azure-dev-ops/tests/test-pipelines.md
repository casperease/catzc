# pwsh/Azure.DevOps/tests/Test-Pipelines.Tests.ps1

The L0 tests of the quality gate that checks the pipelines tree against the naming-and-placement contract.

## Isolation

The tests isolate the gate through the classifier and reference-scan seams, so the file records and the template references are its only
inputs ([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)).

## comment:1

Above `$script:networkPoolInclude = '/.ado/pipelines/variables/network-agent-pool.yaml'`, written with `#`.

```text
The jobs of one pipeline YAML that run a vault-writing command off the network agent pool: a job (a mapping with a job key or a pool)
whose steps run one of the commands, and whose pool is not the declared variable, carries a vmImage, or sits in a file without the
variable template.
```

## comment:2

Above `$script:findServiceConnectionUses = {`, written with `#`.

```text
Every service connection one pipeline YAML names literally, with the identity its use needs: a Foundations or Discoveries entry
deploys the landing zone, an Expeditions entry the workload, a step that writes a foundation vault the landing zone, and any other
step only reads.
```

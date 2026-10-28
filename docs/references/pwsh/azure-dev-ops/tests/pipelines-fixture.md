# pwsh/Azure.DevOps/tests/Pipelines.Fixture.ps1

The shared test fixture of the pipeline tests: the finders that walk one pipeline YAML for its deploys, its production targets, its
vault-writing jobs and its service connections, dot-sourced by `Test-Pipelines.Tests.ps1` and `Test-Pipelines.Tree.Tests.ps1`.

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

# pwsh/Azure.DevOps/tests/types/PipelineEnvConfig.Tests.ps1

The L0 tests of the `pipeline-env.yml` type. Constructing the type maps and validates the parsed YAML, so a malformed whitelist never loads
through `Get-Config -Config pipeline-env`.

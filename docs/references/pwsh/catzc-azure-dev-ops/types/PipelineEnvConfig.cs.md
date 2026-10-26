# pwsh/Azure.DevOps/types/PipelineEnvConfig.cs

The typed record for `pipeline-env.yml`, the pipeline-diagnostics whitelist: a top-level sequence of environment variable names that
`Write-AdoEnvironmentDiagnostic` prints (build context, paths, agent information). The YAML has no top-level key, so the sequence is exposed
as `variables`. The record is registered in `Catzc.Base.Config/configs/configs.yml`, so `Get-Config -Config pipeline-env` returns it.

## Validation

Constructing the record maps and validates the parsed YAML and gathers every violation into one throw:

- the file is a non-empty sequence, so a mapping or a scalar is rejected;
- each entry is an environment variable name matching `^[A-Za-z_][A-Za-z0-9_]*$`, a scalar and never a map or a list;
- names are unique case-insensitively, because Windows environment variable names are case-insensitive.

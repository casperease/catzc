# docs/references/automation/catzc-azure-devops/types/PipelineEnvConfig.cs.md

`automation/Catzc.Azure.DevOps/types/PipelineEnvConfig.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The pipeline-diagnostics whitelist, configs/pipeline-env.yml: a top-level SEQUENCE of environment variable
names that Write-AdoEnvironmentDiagnostic prints at the top of every Invoke-AdoScript run (build context,
paths, agent info). The YAML has no top-level key, so the sequence is exposed as `variables`. Constructing an
instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.PipelineEnvConfig), so
Get-Config -Config pipeline-env returns this typed model.

Load-time rules:
  - the file is a non-empty sequence (a mapping or a scalar is rejected);
  - each entry is an environment variable name (^[A-Za-z_][A-Za-z0-9_]*$) — a scalar, never a map or a list;
  - names are unique case-insensitively (Windows environment variable names are case-insensitive).
```

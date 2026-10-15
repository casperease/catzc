---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/Set-AdoPipelineVariable.ps1.md
    kind: comment-page
    body_sha: "1985951588fe"
    adrs:
      - ADR-PWSH-ANNOUNCE#1
---

# automation/Catzc.Azure.DevOps/Set-AdoPipelineVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Wraps the ##vso[task.setvariable] command with output/secret flags
and automatic no-op when running outside a pipeline.

By default, throws if the variable name contains characters that ADO
silently replaces during downstream resolution (. - '). This prevents
hard-to-debug mismatches between the name you set and the name you
reference. Use -SanitizeName to opt into automatic replacement instead.

When running locally (Test-IsRunningInPipeline returns false), the function
logs the variable but does not emit the ##vso command.

The ##vso command is written like every other console line, through the
writer chokepoint (Write-Message -NoHeader,
[ADR-PWSH-ANNOUNCE#1](/docs/adr/pwsh/announce-state-changes.md#rule-adr-pwsh-announce1)): the host
renders an information record to stdout exactly as it renders Write-Host,
which is where the agent reads logging commands. Being an ordinary record, it
honours 6> redirection, and a Pester run silences it — so a test run in a
pipeline never sets a real pipeline variable.
```

## comment:2

Section `.PARAMETER Value` of the comment-based help.

```text
The variable value. Empty strings are allowed so callers can clear
a variable or signal "no value" to downstream jobs.
```

## comment:3

Section `.PARAMETER IsOutput` of the comment-based help.

```text
Mark as an output variable, accessible from downstream jobs via
dependencies.JobName.outputs['StepName.VariableName'].
```

## comment:4

Section `.PARAMETER IsSecret` of the comment-based help.

```text
Mark as secret. ADO masks the value in all log output.
The function also omits the value from its own Write-Message output.
```

## comment:5

Section `.PARAMETER SanitizeName` of the comment-based help.

```text
Replace . - ' with underscores instead of throwing. Use when the caller
intentionally passes names with these characters (e.g. environment.template
patterns from dynamic key generation).
```

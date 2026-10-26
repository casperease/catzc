# .ado/pipelines/ci-pwsh-expected-failures.yaml

The CI pipeline that proves the guardrails work: it runs commands that must fail, each step with `continueOnError`, so a step that fails as
expected goes amber and the job still succeeds. A guard that stops failing shows as a green step among the amber ones.

## What it runs

It runs on `main` and in pull requests that touch `pwsh/**`. Each step runs on its own and expects its failure:

- **Trap** — `Assert-True $false` through `Invoke-AdoScript.ps1` triggers the error trap and its stack trace.
- **Multiline guard** — a multiline command without a display name must throw. The step repeats the check `invoke-automation.yaml` makes
  internally, and the throw propagates so the step goes amber.
- **Exit code** — `Invoke-Executable` with a non-zero exit code throws.
- **Install guards** — `Install-Python`, `Install-Dotnet` and `Install-NodeJs` refuse to run in a pipeline.

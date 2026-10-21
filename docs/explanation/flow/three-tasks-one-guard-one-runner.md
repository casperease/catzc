# Three tasks share one guard, and one runner imports, traps, sanitizes and invokes

```text
Three tasks share one guard, and one runner imports, traps, sanitizes and invokes.

1  ci-pwsh.yaml            a root pipeline names the template and passes a RunCommand
2  invoke-automation.yaml  seven parameters; Mode picks one of three tasks
3  inline guard            Set-StrictMode, then a multiline RunCommand needs a DisplayName
4  throw                   stops the step before the runner starts
5  importer.ps1            dot-sourced once by the runner
6  trap                    reports failures through Write-Exception
7  sanitize                ConvertFrom-AdoPipelineCommand normalizes the string
8  Invoke-Command          runs the command with -NoNewScope

Supports FDR-CD-RUNNER-NOINLINEPOWERSHELL, FDR-CD-RUNNER-IMPORTONCE and FDR-CD-RUNNER-THINSTEPTEMPLATES (implementation lens).
```

Every ado pipeline step in cats runs through two files: the step template `.ado/pipelines/steps/invoke-automation.yaml` and the runner
`.ado/pipelines/Invoke-AdoScript.ps1`. The template has three task variants, one per authentication mode, and all three carry the same
inline guard before they call the runner. The runner then does four things in a fixed order. Read in code order, the path from a pipeline's
`RunCommand` to the running command has no other stops.

![Three tasks, one guard, one runner](.assets/three-tasks-one-guard-one-runner/diagram.drawio.png)

## Walkthrough

1. **ci-pwsh.yaml.** A root pipeline names the template and passes a command, for example
   `RunCommand: "Test-Automation -Level 2 -EnforceTimings"`.
2. **invoke-automation.yaml.** The template takes seven parameters: `RunCommand`, `Mode` (`none`, `azcli` or `azps`, default `none`),
   `ExposeAccessToken`, `ServiceConnection`, `AllowWarnings`, `DisplayName` and `StepName`. `Mode` picks one of three tasks, `PowerShell@2`,
   `AzureCLI@2` or `AzurePowerShell@5`; each task's `displayName` is `coalesce(DisplayName, RunCommand)`, a set `StepName` names the task so
   a later stage can read its output variables, and `ExposeAccessToken` maps `SYSTEM_ACCESSTOKEN` on any of them.
3. **Inline guard.** All three tasks run `Set-StrictMode -Version Latest`, then check that a multiline `RunCommand` has a `DisplayName`.
   When it passes, the task dot-sources the runner with `-Command`, `-Mode`, `-ExposeAccessToken`, `-ServiceConnection` and
   `-AllowWarnings`.
4. **Throw.** A multiline command without a display name stops the step with
   `Multiline RunCommand requires DisplayName parameter. Add: DisplayName: 'short description'`, before the runner starts.
5. **importer.ps1.** The runner dot-sources the importer with `-AllowWarnings:$AllowWarnings`, loading the module system once. When the
   pipeline variable `SYSTEM_DEBUG` is `true`, it then turns on verbose output.
6. **Trap.** `trap { Write-Exception $_; break }` is set after the import, so it reports failures in the sanitizer and the command, not in
   the import itself.
7. **Sanitize.** `ConvertFrom-AdoPipelineCommand` turns CRLF and stray CR into LF, trims the string, and trims the end of every line.
   Between sanitizing and invoking, the runner only logs: the mode label, the service connection, the token flag, the environment
   diagnostics, and the sanitized command.
8. **Invoke-Command.** `[ScriptBlock]::Create($sanitized)` runs with `Invoke-Command -NoNewScope`, in the importer's scope.

A developer reproduces the step by loading `.\importer.ps1` and typing the same `RunCommand`. That path has no guard, no sanitizer and no
trap, and no code runs it, so it is not drawn.

## Why it holds

- YAML never holds inline PowerShell beyond calling the runner; the template's tasks are the one place that calls it
  (FDR-CD-RUNNER-NOINLINEPOWERSHELL).
- The runner imports the module system once at its start, and the command runs in the same scope (FDR-CD-RUNNER-IMPORTONCE).
- The step template adds pipeline concerns, such as the service connection, the token and the display name
  (FDR-CD-RUNNER-THINSTEPTEMPLATES).

## Where the code and the ADR differ

- The ADR lists four template parameters; the template has seven, adding `AllowWarnings`, `DisplayName` and `StepName`.
- The ADR's runner listing leaves out the `SYSTEM_DEBUG` verbose switch, the logging and the diagnostics between sanitizing and invoking.
- The ADR says the step template holds no logic; the inline guard in each task is logic.

## See also

- [Pipeline runner pattern](../../drs/flow/pipeline-runner-pattern.md) — the decision this article explains.
- The other lenses on the same runner: [meta](a-step-only-names-a-command.md), [architecture](the-runner-is-the-only-seam.md),
  [operations](the-step-is-named-after-its-command.md) and [governance](no-gate-checks-rules-one-and-four.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

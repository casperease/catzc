# The Azure DevOps step is named after its command, and its log echoes the command before it runs

```text
The Azure DevOps step is named after its command, and its log echoes the command before it runs.

1  pipeline step             the author writes a RunCommand, a Mode and a DisplayName
2  step label                the DisplayName, or else the RunCommand itself
3  guard throw               a multiline RunCommand without a DisplayName fails the step
4  Invoke-Automation [Mode]  the log's mode line, then connection, token and diagnostics
5  echoed command            the sanitized command, then its own output
6  Write-Exception           type, message, stack trace and inner exceptions; the run stops
7  developer                 runs .\importer.ps1 and pastes the RunCommand; no gate checks it

Supports ADR-FLOW-CD-RUNNER-THINSTEPTEMPLATES and ADR-FLOW-CD-RUNNER-DEVELOPERREPRODUCIBLE (operations lens).
```

What an author writes in a pipeline is what the Azure DevOps run shows. The step's label is its command, the log names the mode and then
echoes the command it is about to run, and a failure prints a full exception before the run stops. A developer who wants to reproduce a
failed step copies the command from the label and runs it after the importer.

![The step is named after its command](.assets/the-step-is-named-after-its-command/diagram.drawio.png)

## Walkthrough

1. **Pipeline step.** The author writes a `RunCommand`, plus a `Mode` and a `DisplayName` when needed, in a step that uses the template.
2. **Step label.** The step's label is its `DisplayName`, or else the `RunCommand` itself, so the Azure DevOps UI shows exactly what ran
   rather than a generic "Run PowerShell script" label.
3. **Guard throw.** A multiline `RunCommand` without a `DisplayName` fails the step before the runner starts, with
   `Multiline RunCommand requires DisplayName parameter.`
4. **Invoke-Automation [Mode].** The log opens with the mode label, a bare `Invoke-Automation` when the mode is `none`. Then come
   `ServiceConnection: …` and `ExposeAccessToken: true` when they are set, and the environment diagnostics.
5. **Echoed command.** The log shows the sanitized command, then the command's own output.
6. **Write-Exception.** A command that throws prints the exception type, its message, the script stack trace and any inner exceptions, and
   the run stops.
7. **Developer.** To reproduce a step, a developer runs `.\importer.ps1` and pastes the `RunCommand`, copied from the step label or the
   echoed command. No gate checks this reproduction, so it holds by the ADR alone.

Set the pipeline variable `System.Debug` to `true` for verbose output and the full `Write-EnvironmentDiagnostic`; otherwise the log carries
the shorter `Write-AdoEnvironmentDiagnostic`. The `ci-automation-expected-failures.yaml` pipeline exercises the trap and a copy of the guard
on every `pwsh/**` change.

## Why it holds

- Step templates add pipeline concerns such as the display name, and never contain logic (ADR-FLOW-CD-RUNNER-THINSTEPTEMPLATES).
- Whatever string appears in `RunCommand` can be pasted into a local terminal after running `.\importer.ps1`
  (ADR-FLOW-CD-RUNNER-DEVELOPERREPRODUCIBLE).

## Where the code and the ADR differ

- No gate checks that a pasted `RunCommand` reproduces the step: nothing replays a command outside the runner.
- The ADR's runner listing leaves out the log lines and diagnostics that the run shows.
- The ADR says the step template holds no logic; the guard that throws on a multiline command without a display name lives in the template.

## See also

- [Pipeline runner pattern](../../adr/flow/pipeline-runner-pattern.md) — the decision this article explains.
- The other lenses on the same runner: [meta](a-step-only-names-a-command.md), [architecture](the-runner-is-the-only-seam.md),
  [implementation](three-tasks-one-guard-one-runner.md) and [governance](no-gate-checks-rules-one-and-four.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

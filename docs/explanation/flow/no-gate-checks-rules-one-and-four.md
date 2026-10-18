# No gate checks the runner rules 1 or 4, and the step template breaks rule 3

```text
No gate checks the runner rules 1 or 4, and the step template breaks rule 3.

1  pipeline YAML                rule 1: no inline PowerShell; holds, but no gate checks it
2  step template                rule 3: a thin wrapper; its guard contradicts it
3  runner                       rule 2: import once, run in the same scope; holds
4  same RunCommand              rule 4: developer-reproducible; no gate checks it
5  Test-Pipelines               checks ADR-PIPE-NAME rule 4 (absolute template paths), no runner rule
6  expected-failures 1b         replays its own copy of the template's guard
7  expected-failures - Pester   steps 1a and 1c prove the trap; Pester covers the sanitizer

Supports ADR-FLOW-CD-RUNNER#1, #2, #3 and #4, and ADR-PIPE-NAME#4 (governance lens).
```

The pipeline runner pattern has four rules, one for each stage a pipeline step passes through: the YAML, the step template, the runner and
the command. The stages run left to right, each calling the next, and the arrows on the diagram show only which gate checks which stage. Two
rules hold today with no gate behind them, the step template contradicts the rule written for it, and the gates that do touch these stages
check something nearby rather than the rule itself.

![No gate checks rules 1 or 4; the template breaks 3](.assets/no-gate-checks-rules-one-and-four/diagram.drawio.png)

The diagram is described element by element in [its asset description](.assets/no-gate-checks-rules-one-and-four/diagram.drawio.md).

## Walkthrough

1. **Pipeline YAML.** Rule 1 says YAML steps never contain inline PowerShell. It holds today: the only inline scripts under `pipelines/` are
   the template's own tasks and the expected-failures pipeline. No gate checks it, so only the ADR keeps it.
2. **Step template.** Rule 3 says the template is a thin wrapper with no logic. The code contradicts it: each of the template's three tasks
   runs `Set-StrictMode` and a guard that throws on a multiline `RunCommand` without a `DisplayName`.
3. **Runner.** Rule 2 says the runner imports the module system once and runs the command in the same scope. `Invoke-AdoScript.ps1` does
   both.
4. **Same RunCommand.** Rule 4 says whatever string appears in `RunCommand` can be pasted into a local terminal after the importer. No code
   replays a `RunCommand` outside the runner, so only the ADR keeps it, and no gate stands below it.
5. **Test-Pipelines.** The pipeline-layout check runs over `pipelines/` and checks ADR-PIPE-NAME#1, #2, #3, #4 and #6. The one that touches
   this stage is ADR-PIPE-NAME#4, that templates are referenced by absolute path. It checks no runner rule. Its L1 test requires zero
   violations over the real tree.
6. **Expected-failures 1b.** Step 1b of `ci-automation-expected-failures.yaml` proves that a multiline command without a display name
   throws, but it replays its own copy of the guard rather than running the template's. The pipeline itself is the sanctioned exception to
   rule 1: it inlines PowerShell on purpose.
7. **Expected-failures and Pester.** Steps 1a and 1c run `Invoke-AdoScript.ps1` to prove that the trap reports a failing command, and the L0
   Pester test for `ConvertFrom-AdoPipelineCommand` covers the sanitizer. No Pester test runs the runner itself.

## Why it holds

- YAML steps never contain inline PowerShell; all PowerShell runs through the runner or a step template that calls it
  (ADR-FLOW-CD-RUNNER#1).
- The runner imports the module system once, and the command runs in the same scope (ADR-FLOW-CD-RUNNER#2).
- Step templates are thin wrappers that add pipeline concerns and never contain logic (ADR-FLOW-CD-RUNNER#3).
- Every command is developer-reproducible: the `RunCommand` string runs as-is in a terminal after the importer (ADR-FLOW-CD-RUNNER#4).
- Templates are referenced by an absolute path under `/pipelines/` (ADR-PIPE-NAME#4).

## Where the code and the ADR differ

- The ADR says the step template holds no logic; each of its three tasks runs a strict-mode guard that throws before the runner starts.
- Step 1b re-implements the template's guard inline, so a change to the template's own guard is not covered by any run.
- No gate checks rule 1 or rule 4, and rule 2 is exercised only through the expected-failures pipeline, never by a Pester test.

## See also

- [Pipeline runner pattern](../../adr/flow/pipeline-runner-pattern.md) — the decision this article explains.
- [Pipeline naming and placement](../../adr/pipelines/pipeline-naming-and-placement.md) — the rules `Test-Pipelines` checks.
- The other lenses on the same runner: [meta](a-step-only-names-a-command.md), [architecture](the-runner-is-the-only-seam.md),
  [implementation](three-tasks-one-guard-one-runner.md) and [operations](the-step-is-named-after-its-command.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

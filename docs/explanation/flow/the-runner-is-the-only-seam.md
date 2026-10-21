# The runner is the only seam from pipeline YAML into PowerShell

```text
The runner is the only seam from pipeline YAML into PowerShell.

1  pipeline YAML           the ci-* and cd-* root pipelines; 6 of 7 reach the template
2  invoke-automation.yaml  the one step template every step goes through
3  task by Mode            PowerShell@2, AzureCLI@2 or AzurePowerShell@5; owns the auth
4  Invoke-AdoScript.ps1    the runner: imports once, sanitizes, runs in the same scope
5  importer.ps1            loads the modules under pwsh/
6  developer               dot-sources the importer and types the same command

Supports FDR-CD-RUNNER-NOINLINEPOWERSHELL, FDR-CD-RUNNER-IMPORTONCE and FDR-CD-RUNNER-THINSTEPTEMPLATES (architecture lens).
```

Azure DevOps runs YAML steps, and cats keeps its automation in PowerShell modules. The bridge between the two is a critical boundary, so
cats gives it exactly one crossing: pipeline YAML calls one step template, the template selects one task, and the task calls one runner
script, which loads the module system. A developer reaches the same module system from a terminal without passing through the YAML, the
template or the task.

![The runner is the only seam into PowerShell](.assets/the-runner-is-the-only-seam.drawio.png)

## Walkthrough

1. **Pipeline YAML.** The `ci-*` and `cd-*` root pipelines declare what to run and never hold PowerShell. Six of the seven root pipelines
   reach the step template: `ci-pwsh`, `ci-infrastructure` and `cd-shared` call it directly, and `cd-apex`, `cd-flux` and `cd-nova` extend
   `extends/cd-customer.yaml`, which calls it. The seventh, `ci-pwsh-expected-failures`, is the one sanctioned exception.
2. **invoke-automation.yaml.** The step template is the single file every step goes through. It takes the `RunCommand` and a `Mode`, and
   adds pipeline concerns: the service connection, the access token and the display name.
3. **Task by Mode.** The template expands into one task: `PowerShell@2`, `AzureCLI@2` or `AzurePowerShell@5`. The Azure tasks own the
   authentication, taking the service connection as their `azureSubscription`; the runner only logs which connection it ran under.
4. **Invoke-AdoScript.ps1.** The runner is the only seam between YAML and PowerShell. It imports the module system once, sanitizes the
   command string with `ConvertFrom-AdoPipelineCommand`, and runs it in the same scope as the import.
5. **importer.ps1.** The importer loads the modules under `pwsh/`, so every function a `RunCommand` names is available without
   qualification.
6. **Developer.** A developer dot-sources the importer in a terminal and types the same command, with no YAML, no task and no runner in
   between.

## Why it holds

- YAML steps never contain inline PowerShell; all PowerShell runs through the runner or the step template that calls it
  (FDR-CD-RUNNER-NOINLINEPOWERSHELL).
- The runner imports the module system once, at its start, and the command runs in that same scope (FDR-CD-RUNNER-IMPORTONCE).
- The step template is a thin wrapper that adds pipeline concerns but no logic (FDR-CD-RUNNER-THINSTEPTEMPLATES).

## Where the code and the decision record differ

The FDR says the step template holds no logic, but each of its three tasks runs a strict-mode guard that throws on a multiline `RunCommand`
without a `DisplayName` before it calls the runner.

## See also

- [Pipeline runner pattern](../../drs/flow/pipeline-runner-pattern.md) — the decision this article explains.
- The other lenses on the same runner: [meta](a-step-only-names-a-command.md), [implementation](three-tasks-one-guard-one-runner.md),
  [operations](the-step-is-named-after-its-command.md) and [governance](no-gate-checks-rules-one-and-four.md).
- [The flow explanations](index.md) · [How to read the diagrams](../index.md#how-to-read-the-diagrams)

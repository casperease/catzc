# ADR: Pipeline runner pattern — how pipelines invoke automation

## Rules: ADR-FLOW-CD-RUNNER

### Rule ADR-FLOW-CD-RUNNER:1

YAML steps never contain inline PowerShell. All PowerShell execution goes through the runner (`Invoke-AdoScript.ps1`) or a step template
that calls it.

- [The runner pattern](#the-runner-pattern)
- [Decision](#decision)

### Rule ADR-FLOW-CD-RUNNER:2

The runner imports the module system once at the start of `Invoke-AdoScript.ps1`, and the command runs in the same scope (`-NoNewScope`).

- [The runner](#the-runner)
- [Why a dedicated runner script](#why-a-dedicated-runner-script)

### Rule ADR-FLOW-CD-RUNNER:3

Step templates are thin wrappers: they add pipeline concerns (service connections, token injection, display names) but never contain logic.

- [The step template](#the-step-template)

### Rule ADR-FLOW-CD-RUNNER:4

Commands are developer-reproducible: whatever string appears in `RunCommand` can be pasted into a local terminal after running
`.\importer.ps1`.

- [Pipeline usage](#pipeline-usage)

## Context

Azure DevOps pipelines execute YAML steps. PowerShell automation lives in modules under `automation/`. The bridge between them — how a YAML
step invokes a PowerShell function — is a critical boundary.

### The naive approach

The tempting approach is to inline PowerShell directly in each YAML step:

```yaml
- pwsh: |
    . ./importer.ps1
    Install-DevBoxTools
    Test-Automation
```

This works but scales poorly. Every step reimports the module system from scratch, duplicates the importer invocation, and scatters
PowerShell logic across YAML files where it cannot be tested, linted, or reused. When the import pattern changes, every pipeline must be
updated.

### The runner pattern

A single `Invoke-AdoScript.ps1` script acts as the universal entry point for all pipeline steps. It handles bootstrapping (importing
modules, setting preferences) once, then executes whatever command the pipeline passes in.

The YAML layer becomes purely declarative — it names the command to run and any pipeline-specific concerns (service connections, environment
approvals, checkout depth). It never contains PowerShell logic.

### Why a dedicated runner script

**Single point of bootstrap.** The importer, error handling, and trap setup live in one place. When the bootstrap pattern changes, one file
changes — not every pipeline.

**Testable commands.** The `RunCommand` passed to the runner is the same command a developer types interactively. You can reproduce any
pipeline step by running the same command locally. No YAML-specific behavior to account for.

**Separation of concerns.** YAML handles pipeline orchestration (triggers, environments, approvals, artifacts). PowerShell handles
automation logic. The runner is the only seam between them.

## Decision

All pipeline steps invoke PowerShell through a runner script. YAML steps never contain inline PowerShell logic beyond calling the runner.

### Structure

```text
pipelines/
  Invoke-AdoScript.ps1             # universal pipeline entry point
  steps/
    invoke-automation.yaml         # unified step template with Mode and security flags
```

### The runner

`Invoke-AdoScript.ps1` accepts a command string, bootstraps the module system, sanitizes YAML/ADO escaping artifacts via
`ConvertFrom-AdoPipelineCommand`, and executes the command:

```powershell
param(
    [Parameter(Mandatory)] [string] $Command,
    [string] $Mode = 'none',
    [switch] $ExposeAccessToken,
    [string] $ServiceConnection,
    [switch] $AllowWarnings
)

. $PSScriptRoot/../importer.ps1 -AllowWarnings:$AllowWarnings
trap { Write-Exception $_; break }

$sanitized = ConvertFrom-AdoPipelineCommand $Command
$block = [ScriptBlock]::Create($sanitized)
Invoke-Command -ScriptBlock $block -NoNewScope
```

The `-NoNewScope` flag ensures the command runs in the same scope as the importer, so all imported functions are available without
qualification.

The auth parameters are thin: `Mode`, `ServiceConnection`, and `ExposeAccessToken` are surfaced for diagnostics (the script logs which
connection/mode it ran under) — the actual authentication is performed by the wrapping ADO task the step template selects (`AzureCLI@2` /
`AzurePowerShell@5`), not by the runner. `AllowWarnings` is forwarded to the importer so a warning-noisy load does not fail the step.

`ConvertFrom-AdoPipelineCommand` normalizes line endings, trims whitespace artifacts from YAML indentation, and preserves intentional
newlines for multiline command support.

### The step template

`invoke-automation.yaml` is a single template with flags for authentication mode and credential exposure:

```yaml
parameters:
  - name: RunCommand # The command to execute
  - name: Mode # none | azcli | azps — selects the task type
  - name: ExposeAccessToken # Maps SYSTEM_ACCESSTOKEN when true
  - name: ServiceConnection # Required when Mode is azcli or azps
```

| Mode    | Task                | Credentials in env vars?               |
| ------- | ------------------- | -------------------------------------- |
| `none`  | `PowerShell@2`      | None                                   |
| `azcli` | `AzureCLI@2`        | None — az CLI auth is task-internal    |
| `azps`  | `AzurePowerShell@5` | None — Az module auth is task-internal |

`ExposeAccessToken` is orthogonal — adds `SYSTEM_ACCESSTOKEN` on any mode.

### Pipeline usage

```yaml
# Plain command — no auth
- template: /pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: "Test-Automation"

# Azure CLI + system token
- template: /pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: "Deploy-Bicep -Environment dev -Template sample"
    Mode: azcli
    ExposeAccessToken: true
    ServiceConnection: "sc-my-subscription"

# Multiline command (YAML pipe operator)
- template: /pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: |
      Build-Bicep -Template sample -Environments dev
      Deploy-Bicep -Environment dev -Template sample
    Mode: azcli
    ServiceConnection: "sc-my-subscription"
```

The `displayName` mirrors the command, so the ADO UI shows exactly what ran — no "Run PowerShell script" labels.

### Exception

- **The guardrail pipeline inlines PowerShell on purpose.** `ci-automation-expected-failures.yaml` deliberately dot-sources `importer.ps1`
  inline (and invokes `Invoke-AdoScript.ps1` directly with raw `PowerShell@2` tasks) to prove that the guardrails fail as designed — e.g.
  that a multiline `RunCommand` without a `DisplayName` throws. Its job is to exercise the bootstrap and the runner's own failure modes,
  which is precisely the seam the step template would otherwise hide. This is a sanctioned deviation from "all logic via the runner," scoped
  to that one expected-failures pipeline; production pipelines still go through `Invoke-AdoScript.ps1` via the step template.

## Consequences

- Pipeline YAML is declarative and reviewable by anyone — no PowerShell knowledge required to understand the flow.
- Bootstrap changes are a single-file edit, not a pipeline-wide search-and-replace.
- Every pipeline step is locally reproducible by running the same command after the importer.
- Step templates compose cleanly — add authentication, artifact handling, or diagnostics without touching the command.
- The runner is itself testable — import + execute is a pure pattern with no hidden state.

# .ado/pipelines/steps/invoke-automation.yaml

The unified step template for running a catzc command in a pipeline. It runs the command through `Invoke-AdoScript.ps1`, in the task that
the authentication mode selects ([ADR-ADO-RUNNER](../../../../drs/ado/pipeline-runner-pattern.md)).

## Usage

A single-line command needs only `RunCommand`. A multiline command is a YAML block and needs a `DisplayName`, or the step throws:

```yaml
- template: /.ado/pipelines/steps/invoke-automation.yaml
  parameters:
    RunCommand: |
      Build-Bicep -Template sample -Environments dev
      Deploy-Bicep -Environment dev -Template sample
    DisplayName: "Build and deploy the sample"
    Mode: azcli
    ServiceConnection: "sc-my-subscription"
```

## Parameters

- **`RunCommand`** — the command to execute.
- **`Mode`** — `none` (default, `PowerShell@2`), `azcli` (`AzureCLI@2`) or `azps` (`AzurePowerShell@5`). The two Azure modes need a
  `ServiceConnection`.
- **`ExposeAccessToken`** — maps `SYSTEM_ACCESSTOKEN`, for the ADO API, NuGet feeds and git auth.
- **`AllowWarnings`** — downgrades warnings from errors to non-terminating.
- **`DisplayName`** — the step name; for a single-line command it defaults to the command.
- **`StepName`** — gives the step a name, so a later stage can read its output variables.

## Security

All flags default to off, and each is an explicit escalation. No credentials leak to environment variables in any mode.

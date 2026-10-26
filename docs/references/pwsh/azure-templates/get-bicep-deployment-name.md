# pwsh/Azure.Templates/Get-BicepDeploymentName.ps1

The function that builds an ARM deployment name for a bicep template, from the template, the slot, the build id and the short commit.

## help

### synopsis

Builds an ARM deployment name for a bicep template.

### description

Pattern: `<Template>-<slotName>-<buildId>-<commit>`, where slotName is the slot (the env's `<env>` or `<env>-<slot>`) — so two slots of one
template never collide on a name. The subscription is NOT in the name: deployment names are scoped per subscription (group create
--subscription / sub create), so the same name in two subscriptions never collides.

On a pipeline agent (Test-IsRunningInPipeline → $true), the buildId and commit are read from the host CI's env vars — Azure DevOps
(`BUILD_BUILDID` / `BUILD_SOURCEVERSION`) or GitHub Actions (`GITHUB_RUN_ID` / `GITHUB_SHA`); the commit is truncated to 7 chars.

On a devbox, placeholders ('xCLIxx' / 'xxxxxxx') are used — devbox deploys are dev-only iterations and we deliberately avoid coupling to git
here.

Asserts the result is 11..64 chars (ARM's 64-char deployment-name limit).

### parameter `Template`

Template name (folder under infrastructure/templates/).

### parameter `Environment`

Environment name (selects the slot — its base slot when no -Slot).

### parameter `Slot`

Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Omitted selects the env's base / index-0 slot.

### example 1

```powershell
Get-BicepDeploymentName sample -Environment dev              # -> sample-dev-...
```

### example 2

```powershell
Get-BicepDeploymentName sample -Environment prod -Slot 001   # -> sample-prod-001-...
```

## Pipeline variables

The function already knows it is in a pipeline, because the one sanctioned detector said so. It reads only each platform's run-id and commit
data variables, never the detection variables `TF_BUILD` and `GITHUB_ACTIONS`, which only `Test-IsRunningInPipeline` may read
([FDR-CD-DETECT-NODIRECTVARIABLECHECK](../../../drs/flow/pipeline-detection.md#rule-fdr-cd-detect-nodirectvariablecheck), enforced by
`Measure-NoRawPipelineDetection`).

GitHub Actions sets `GITHUB_RUN_ID` and `GITHUB_SHA`, and Azure DevOps sets `BUILD_BUILDID` and `BUILD_SOURCEVERSION`. The commit is
truncated to 7 characters. Outside a pipeline the name carries the placeholders `xCLIxx` and `xxxxxxx`.

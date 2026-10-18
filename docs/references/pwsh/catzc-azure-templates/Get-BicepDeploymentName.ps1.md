# pwsh/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `if ($env:GITHUB_RUN_ID) {`, written with `#`.

```text
We already know we're in a pipeline (the one sanctioned detector said so); here we only read each
platform's run-id / commit DATA vars — not the detection vars TF_BUILD / GITHUB_ACTIONS, which only
Test-IsRunningInPipeline may read (rule
[ADR-FLOW-CD-DETECT-NODIRECTVARIABLECHECK](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect-nodirectvariablecheck) /
Measure-NoRawPipelineDetection). GitHub Actions sets
GITHUB_RUN_ID / GITHUB_SHA; Azure DevOps sets BUILD_BUILDID / BUILD_SOURCEVERSION. The commit is
truncated to 7 chars.
```

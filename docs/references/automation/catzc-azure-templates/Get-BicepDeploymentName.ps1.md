---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
    kind: comment-page
    body_sha: "069bf26c2cb6"
    adrs:
      - ADR-FLOW-CD-DETECT#1
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Pattern: `<Template>-<slotName>-<buildId>-<commit>`, where slotName is the slot (the env's
`<env>` or `<env>-<slot>`) — so two slots of one template never collide on a name. The subscription
is NOT in the name: deployment names are scoped per subscription (group create --subscription / sub
create), so the same name in two subscriptions never collides.

On a pipeline agent (Test-IsRunningInPipeline → $true), the buildId and commit are read from the host
CI's env vars — Azure DevOps (`BUILD_BUILDID` / `BUILD_SOURCEVERSION`) or GitHub Actions
(`GITHUB_RUN_ID` / `GITHUB_SHA`); the commit is truncated to 7 chars.

On a devbox, placeholders ('xCLIxx' / 'xxxxxxx') are used — devbox deploys are dev-only
iterations and we deliberately avoid coupling to git here.

Asserts the result is 11..64 chars (ARM's 64-char deployment-name limit).
```

## comment:2

Section `.PARAMETER Slot` of the comment-based help.

```text
Optional special-slot discriminator (1-3 lowercase alphanumeric chars, `001`). Omitted selects the
env's base / index-0 slot.
```

## comment:3

Above `if ($env:GITHUB_RUN_ID) {`.

```text
We already know we're in a pipeline (the one sanctioned detector said so); here we only read each
platform's run-id / commit DATA vars — not the detection vars TF_BUILD / GITHUB_ACTIONS, which only
Test-IsRunningInPipeline may read (rule
[ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1) /
Measure-NoRawPipelineDetection). GitHub Actions sets
GITHUB_RUN_ID / GITHUB_SHA; Azure DevOps sets BUILD_BUILDID / BUILD_SOURCEVERSION. The commit is
truncated to 7 chars.
```

## comment:4

Above `if ($env:GITHUB_RUN_ID) {`.

```text
We already know we're in a pipeline (the one sanctioned detector said so); here we only read each
platform's run-id / commit DATA vars — not the detection vars TF_BUILD / GITHUB_ACTIONS, which only
Test-IsRunningInPipeline may read (rule
[ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1) /
Measure-NoRawPipelineDetection). GitHub Actions sets
GITHUB_RUN_ID / GITHUB_SHA; Azure DevOps sets BUILD_BUILDID / BUILD_SOURCEVERSION. The commit is
truncated to 7 chars.
```

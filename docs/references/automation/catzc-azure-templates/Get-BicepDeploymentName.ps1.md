---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
    kind: comment-page
    body_sha: "5887f21e96e8"
    adrs:
      - ADR-FLOW-CD-DETECT#1
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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

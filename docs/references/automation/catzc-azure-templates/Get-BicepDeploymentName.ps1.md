---
catzc:
  immutable:
    with_body_sha: "3ed45472cd11"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/Get-BicepDeploymentName.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-bicep-deployment-name-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-FLOW-CD-DETECT#1
---

# automation/Catzc.Azure.Templates/Get-BicepDeploymentName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($env:GITHUB_RUN_ID) {`, written with `#`.

```text
We already know we're in a pipeline (the one sanctioned detector said so); here we only read each
platform's run-id / commit DATA vars — not the detection vars TF_BUILD / GITHUB_ACTIONS, which only
Test-IsRunningInPipeline may read (rule
[ADR-FLOW-CD-DETECT#1](/docs/adr/flow/pipeline-detection.md#rule-adr-flow-cd-detect1) /
Measure-NoRawPipelineDetection). GitHub Actions sets
GITHUB_RUN_ID / GITHUB_SHA; Azure DevOps sets BUILD_BUILDID / BUILD_SOURCEVERSION. The commit is
truncated to 7 chars.
```

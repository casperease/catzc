---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md
    kind: comment-page
    body_sha: ccf9492cbf7e
    adrs: []
---

# automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The "land via PR" half of an INPUT pipeline (see [ADR-FLOW-CD-TYPE](/docs/adr/flow/pipeline-types.md)): once an
INPUT step has committed a config change to a branch, this opens a PR so the change goes through the
normal PR gate before the CD pipeline deploys it.

Resolves the repository by name, normalizes branch names to refs/heads/<branch>, and POSTs the PR.
Authentication is the dual-auth pattern via Invoke-AdoRestMethod / Get-AdoAuthorizationHeader
(pipeline SYSTEM_ACCESSTOKEN, PAT, or az login).
```

## comment:2

Section `.PARAMETER SourceBranch` of the comment-based help.

```text
The branch with the change (e.g. 'input/discovery-dev-1234'). Accepts a bare branch name or
a full 'refs/heads/...' ref.
```

## comment:3

Above `Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned...`.

```text
Postcondition: confirm the PR actually came back created. A non-throwing response with no id means the
create did not take effect — fail fast here rather than return a phantom result downstream.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md
    kind: comment-page
    body_sha: "679f88c9df71"
---

# automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned...`.

```text
Postcondition: confirm the PR actually came back created. A non-throwing response with no id means the
create did not take effect — fail fast here rather than return a phantom result downstream.
```

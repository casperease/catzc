---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/New-AdoPullRequest.ps1.md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: f944fad90de3
---

# automation/Catzc.Azure.DevOps/New-AdoPullRequest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Assert-NotNull $pr.pullRequestId -ErrorText "Pull request creation returned...`, written with `#`.

```text
Postcondition: confirm the PR actually came back created. A non-throwing response with no id means the
create did not take effect — fail fast here rather than return a phantom result downstream.
```

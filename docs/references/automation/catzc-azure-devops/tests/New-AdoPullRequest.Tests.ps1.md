---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-devops/tests/New-AdoPullRequest.Tests.ps1.md
    kind: test-asset
    body_sha: "16c2f3bbb0c3"
---

# automation/Catzc.Azure.DevOps/tests/New-AdoPullRequest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock Invoke-AdoRestMethod {`.

```text
Mock the REST boundary: repo lookup returns one repo; the PR POST returns a PR object.
Check pullrequests first — the PR URL also contains 'git/repositories/<id>/'.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-github/tests/Assert-GitHubPurgeReady.Tests.ps1.md
    kind: test-asset
    body_sha: "3bfda7952584"
---

# automation/Catzc.Tooling.Github/tests/Assert-GitHubPurgeReady.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Mock -ModuleName Catzc.Tooling.Github Invoke-Executable { throw "unexpected...`.

```text
A mock body runs in the module's session state, so it cannot reference a test-scope
helper — each result object is inlined. Catch-all first: an unmocked command is a
test-setup bug, not a real launch.
```

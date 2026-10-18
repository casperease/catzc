# automation/Catzc.Azure.DevOps/tests/New-AdoPullRequest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Mock Invoke-AdoRestMethod {`, written with `#`.

```text
Mock the REST boundary: repo lookup returns one repo; the PR POST returns a PR object.
Check pullrequests first — the PR URL also contains 'git/repositories/<id>/'.
```

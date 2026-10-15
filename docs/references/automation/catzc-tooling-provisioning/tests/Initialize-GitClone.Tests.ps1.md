---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Initialize-GitClone.Tests.ps1.md
    kind: test-asset
    body_sha: "1630736b3b73"
---

# automation/Catzc.Tooling.Provisioning/tests/Initialize-GitClone.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Every git invocation goes through Invoke-Executable, so one mock covers the whole external
boundary: rev-parse proves the work tree, `--get` probes report current values, and the
`git config --local <key>` writes are the side effects the tests count.
```

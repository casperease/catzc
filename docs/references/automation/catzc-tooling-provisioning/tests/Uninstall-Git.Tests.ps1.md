---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Uninstall-Git.Tests.ps1.md
    kind: test-asset
    body_sha: "7d799954f2ae"
---

# automation/Catzc.Tooling.Provisioning/tests/Uninstall-Git.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeEach {`.

```text
Every filesystem/PATH/CLI boundary is mocked so nothing is removed for real and no process launches
(the L0 tripwire would throw on a real Invoke-Executable). Platform branches self-skip off-platform.
```

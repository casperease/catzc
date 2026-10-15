---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/tests/Assert-DevBoxToolsStatus.Tests.ps1.md
    kind: test-asset
    body_sha: "257ae3625743"
---

# automation/Catzc.Tooling.Provisioning/tests/Assert-DevBoxToolsStatus.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `BeforeAll {`.

```text
Get-ToolsStatus is the only boundary — mock it to return fabricated ToolStatus rows and assert the
pass/throw decision. The rows use deliberately non-production tool names.
```

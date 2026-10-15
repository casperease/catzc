---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-environment/private/Set-ProcessEnvironmentVariable.ps1.md
    kind: reference
    body_sha: "2af716414cbe"
    adrs: []
---

# automation/Catzc.Tooling.Environment/private/Set-ProcessEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam through which Write-EnvironmentSet WRITES and restores $env: values, wrapping
[Environment]::SetEnvironmentVariable(name, value, 'Process'). A $null value removes the variable (this is
how a scoped restore returns a previously-unset variable to unset). Tests mock this boundary
(`Mock Set-ProcessEnvironmentVariable -ModuleName Catzc.Tooling.Environment`) instead of mutating the real
process environment. This is the deliberately thin, un-mockable I/O boundary, so it has no unit test of its
own (mirrors Set-EnvironmentPath).
```

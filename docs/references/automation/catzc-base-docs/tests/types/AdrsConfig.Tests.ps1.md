---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/tests/types/AdrsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "24435b725e1d"
---

# automation/Catzc.Base.Docs/tests/types/AdrsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `function New-ValidRaw {`.

```text
Neutral fixtures ([ADR-REPO-LANG](/docs/adr/repository/domain-language-separation.md)): invented
domains/codes, never real ADR vocabulary. Defined in
BeforeAll so the helper is in scope for the run phase and visible to every It (a Describe-body function is
only in discovery scope).
```

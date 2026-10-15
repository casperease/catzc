---
catzc:
  derived:
    path: docs/references/automation/catzc-base-environment/Get-PermanentEnvironmentVariable.ps1.md
    kind: comment-page
    body_sha: eb67139bec71
    adrs: []
    links: []
---

# automation/Catzc.Base.Environment/Get-PermanentEnvironmentVariable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single seam through which tooling READS a persistent environment variable other than PATH (PATH has its
own, Get-EnvironmentPath), so a logic test can Mock the registry boundary
(`Mock Get-PermanentEnvironmentVariable -ModuleName <module>`) instead of reading the real user environment.
User/Machine scopes are a Windows concept; callers guard Windows-only use with $IsWindows. The real
registry round trip is proven by the L3 system test in tests/Set-PermanentEnvironmentVariable.Tests.ps1.
```

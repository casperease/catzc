---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Shellcheck.ps1.md
    kind: comment-page
    body_sha: "3bbe8bb7decd"
    adrs: []
---

# automation/Catzc.Tooling.Toolchain/Install-Shellcheck.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
ShellCheck is the analyzer the Test-ShellScripts quality gate runs over every tracked *.sh file
([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)). Windows and macOS delegate to Install-Tool: winget
koalaman.shellcheck as a user-scope portable (no admin), or brew. Linux installs the distribution's shellcheck package
with apt-get, which needs root. Idempotent: a ShellCheck already at the pinned version is left alone; another version
throws unless -Force.
```

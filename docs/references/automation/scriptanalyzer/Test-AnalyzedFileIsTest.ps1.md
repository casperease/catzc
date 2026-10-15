---
catzc:
  derived:
    path: docs/references/automation/scriptanalyzer/Test-AnalyzedFileIsTest.ps1.md
    kind: comment-page
    body_sha: ef4333e6cb87
    adrs: []
    links: []
---

# automation/.scriptanalyzer/Test-AnalyzedFileIsTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Several checks exempt test files, which change state, read raw variables, and use short names on purpose. The
Test-ScriptAnalyzer quality gate runs on files, so the file name decides: a *.Tests.ps1 file, or (for a check
that asks) a file under a tests/ folder. VS Code's PowerShell extension analyzes the open editor buffer instead,
as a script definition with no file name, so the name cannot decide there. Then the content does: a Pester test
file calls Describe, and no automation code does. Every check asks this one function, so the quality gate and
the editor agree.

Dot-sourced into each check module, so it runs in that module's scope and changes no session state.
```

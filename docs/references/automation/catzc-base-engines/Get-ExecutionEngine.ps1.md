---
catzc:
  derived:
    path: docs/references/automation/catzc-base-engines/Get-ExecutionEngine.ps1.md
    kind: comment-page
    body_sha: b7c019f3b0b5
    adrs: []
    links: []
---

# automation/Catzc.Base.Engines/Get-ExecutionEngine.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The repository's own code runs under exactly three execution engines, pwsh, bash and zsh, declared once in the
ExecutionEngines model ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)): each names how its
executable is located, which scripts it runs, how it starts non-interactively, how it loads an entry script and
runs a command (StartArguments), its strict mode, its time safeguard, the line endings and executable bit its
scripts need, and its importer entry. A caller reads what differs between the engines here instead of restating
it.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/Resolve-EngineExecutable.ps1.md
    kind: comment-page
    body_sha: "09e80a6c472c"
    adrs: []
    links: []
---

# automation/Catzc.Base.Execution/Resolve-EngineExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Locates the engine's executable the way its model says (ExecutionEngine.Locate,
[ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)):

  ps-home  pwsh, beside the PowerShell that is running ($PSHOME), so a started engine is the same PowerShell as
           the caller, never another pwsh that comes first on PATH;
  tool     the POSIX engines, through their tools.yml entries and the existence check (Resolve-ToolExecutable): Git
           Bash and the zsh installed into its tree on Windows, the system shell elsewhere, never the WSL launcher.

Throws, naming the engine and the remedy, when the executable is missing or a tool-located one misses its pin.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md
    kind: comment-page
    body_sha: bb9dd0853752
---

# automation/Catzc.Base.Languages/private/Get-EngineContract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {`.

```text
The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the repository,
forward-slashed so a POSIX shell on Windows reads the path.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/private/Get-EngineContract.ps1.md
    kind: comment-page
    body_sha: "7a1da02ca451"
---

# automation/Catzc.Base.Languages/private/Get-EngineContract.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$entry = if ($model.Name -eq [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name) {`, written with `#`.

```text
The entry the engine itself loads: pwsh the PowerShell entry; any other engine its own importer in the repository,
forward-slashed so a POSIX shell on Windows reads the path.
```

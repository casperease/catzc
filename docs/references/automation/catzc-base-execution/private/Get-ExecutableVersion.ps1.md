---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md
    kind: comment-page
    body_sha: "170b31946cc3"
    adrs: []
---

# automation/Catzc.Base.Execution/private/Get-ExecutableVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs the executable at -Path (never whatever its bare name resolves to on PATH) with -Arguments, once, in the
executable's own folder, and matches the merged output against -Pattern. Returns the captured named group (?<ver>...), or $null when the
output does not match. Find-Executable calls it at most once per executable file per session.
```

## comment:2

Above `$folder = [System.IO.Path]::GetDirectoryName($Path)`.

```text
Run in the executable's own folder, never the repository: a tool that reads project files from its working
directory (go's go.work toolchain line, dotnet's global.json) would otherwise report — or download — the
version the project asks for instead of the version the located binary is.
```

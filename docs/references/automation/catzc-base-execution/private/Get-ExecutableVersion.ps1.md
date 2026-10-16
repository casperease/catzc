---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/private/Get-ExecutableVersion.ps1.md
    folder: docs/references/automation/catzc-base-execution/private
    name: get-executable-version-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e09c3882a9af
---

# automation/Catzc.Base.Execution/private/Get-ExecutableVersion.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$folder = [System.IO.Path]::GetDirectoryName($Path)`, written with `#`.

```text
Run in the executable's own folder, never the repository: a tool that reads project files from its working
directory (go's go.work toolchain line, dotnet's global.json) would otherwise report — or download — the
version the project asks for instead of the version the located binary is.
```

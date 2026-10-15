---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Get-DotnetInstallHolder.ps1.md
    kind: reference
    body_sha: e9d1430d7d6f
    adrs: []
---

# automation/Catzc.Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Every running .NET host — the dotnet muxer, an apphost such as VBCSCompiler.exe, an MSBuild node, an
editor's language server — loads the install's host resolver, host/fxr/<version>/hostfxr. The holders of
those files are therefore the processes that would make a delete of the install fail part-way. Each holder
is listed once. Locking is advisory off Windows, so there it lists nothing (Get-FileLockingProcess).
```

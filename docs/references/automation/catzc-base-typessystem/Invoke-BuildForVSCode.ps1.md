---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/Invoke-BuildForVSCode.ps1.md
    kind: comment-page
    body_sha: "2a12e14ec9f7"
---

# automation/Catzc.Base.TypesSystem/Invoke-BuildForVSCode.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above ``$result = Invoke-Executable "dotnet build `"$project`" --configuration...``.

```text
The stamp task's "stamped version …" line and any analyzer diagnostics stream through. A non-zero exit
(a stale committed DLL, an analyzer error) throws via Invoke-Executable.
```

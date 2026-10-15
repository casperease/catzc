---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Build-BashTimeoutHook.Tests.ps1.md
    kind: test-asset
    body_sha: d50b503d7a4d
---

# automation/Catzc.Base.TypesSystem/tests/Build-BashTimeoutHook.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$null = New-Item -ItemType Directory -Force -Path $script:outputDirectory`.

```text
Stand in for `dotnet publish`: copy this host's own executable to where the real publish puts the
program, so it carries the platform's real executable extension and resolves as an application.
```

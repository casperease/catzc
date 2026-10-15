---
catzc:
  derived:
    path: docs/references/automation/catzc-base-typessystem/tests/Build-BashTimeoutHook.Tests.ps1.md
    kind: comment-page
    body_sha: ff7937d1c71b
---

# automation/Catzc.Base.TypesSystem/tests/Build-BashTimeoutHook.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$null = New-Item -ItemType Directory -Force -Path $script:outputDirectory`, written with `#`.

```text
Stand in for `dotnet publish`: copy this host's own executable to where the real publish puts the
program, so it carries the platform's real executable extension and resolves as an application.
```

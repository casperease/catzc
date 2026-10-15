---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/tests/Build-Modules.Tests.ps1.md
    kind: test-asset
    body_sha: "30fc09378512"
---

# automation/Catzc.Base.Exporter/tests/Build-Modules.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `$script:stubbedEngine = $false`.

```text
The engine (Catzc.Internal.Builder) is loaded on demand and is a mocked boundary here; a stub makes the
command exist for Mock when the engine module is not loaded in this session.
```

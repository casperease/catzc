---
catzc:
  immutable:
    with_body_sha: "3b9c17464265"
    path: docs/references/automation/catzc-base-exporter/tests/Build-Modules.Tests.ps1.md
    folder: docs/references/automation/catzc-base-exporter/tests
    name: build-modules-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Exporter/tests/Build-Modules.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:stubbedEngine = $false`, written with `#`.

```text
The engine (Catzc.Internal.Builder) is loaded on demand and is a mocked boundary here; a stub makes the
command exist for Mock when the engine module is not loaded in this session.
```

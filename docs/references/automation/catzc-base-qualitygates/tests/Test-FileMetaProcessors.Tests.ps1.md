---
catzc:
  immutable:
    with_body_sha: "6969acb44afb"
    path: docs/references/automation/catzc-base-qualitygates/tests/Test-FileMetaProcessors.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: test-file-meta-processors-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-REPO-FILEMETA#4
---

# automation/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-FileMetaProcessors' -Tag 'L0', 'logic', 'ADR-REPO-FILEMETA#4' {`, written with `#`.

```text
Test-FileMetaProcessors over in-memory registries and fixture processor functions defined in the module scope.
Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

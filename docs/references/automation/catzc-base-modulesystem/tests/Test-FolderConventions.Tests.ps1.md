---
catzc:
  immutable:
    with_body_sha: c37f4e6e94da
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-FolderConventions.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: test-folder-conventions-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-FolderConventions' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-FolderConventions over fixture module trees in $TestDrive: the repository root is mocked, so each test builds
the folders it needs and pins one convention. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

---
catzc:
  immutable:
    with_body_sha: "7099099b8238"
    repo_status: locked
    path: docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigFiles.Tests.ps1.md
    folder: docs/references/automation/catzc-base-rootconfig/tests
    name: test-root-config-files-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-RootConfigFiles' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-RootConfigFiles over fixture root files in $TestDrive: the registry entries, git's ignore check, and the index
are mocked, so each test pins one agreement rule. A hard link stands in for a materialised link (no privilege
needed). Neutral fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

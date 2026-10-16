---
catzc:
  immutable:
    with_body_sha: "75f88b50d291"
    repo_status: locked
    path: docs/references/automation/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md
    folder: docs/references/automation/catzc-base-languages/tests
    name: new-go-workspace-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`, written with `#`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture config, a fixture tools.yml pin, and a fixture
repository root in $TestDrive.
```

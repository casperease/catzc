---
catzc:
  immutable:
    with_body_sha: "0a5326e0221a"
    path: docs/references/automation/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md
    folder: docs/references/automation/catzc-base-languages/tests
    name: invoke-bash-test-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#6
---

# automation/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$script:root = Join-Path $TestDrive 'repo'`, written with `#`.

```text
Isolate through the seams ([ADR-AUTO-TEST#6](/docs/adr/automation/test-automation.md#rule-adr-auto-test6)): a
fixture repository root in $TestDrive with a stub vendored runner and its importer.sh, a mocked engine probe
(Resolve-EngineExecutable), and a mocked bash (Invoke-Executable) whose bats writes a canned JUnit report from
tests/assets into the output folder the command names.
```

---
catzc:
  immutable:
    with_body_sha: "01bdca0596e3"
    path: docs/references/automation/catzc-base-modulesystem/tests/Test-ModuleDependency.Tests.ps1.md
    folder: docs/references/automation/catzc-base-modulesystem/tests
    name: test-module-dependency-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#35
---

# automation/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1

<!-- cspell:ignore tpols -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ModuleDependency' {`, written with `#`.

```text
Test-ModuleDependency is a quality gate
([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)): each L0 case runs it with
-PassThru over mocked boundaries and reads the collected issues; the report goes to $TestDrive.
```

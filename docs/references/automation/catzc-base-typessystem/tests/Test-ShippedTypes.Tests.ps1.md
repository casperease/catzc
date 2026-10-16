---
catzc:
  immutable:
    with_body_sha: b92ee29f2c31
    repo_status: locked
    path: docs/references/automation/catzc-base-typessystem/tests/Test-ShippedTypes.Tests.ps1.md
    folder: docs/references/automation/catzc-base-typessystem/tests
    name: test-shipped-types-tests-ps1
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

# automation/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Test-ShippedTypes' -Tag 'L0', 'logic' {`, written with `#`.

```text
Test-ShippedTypes over a fixture code root in $TestDrive: one file named for a type the session has (System.String
under a 'System' module folder), one named for a type that never loaded. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

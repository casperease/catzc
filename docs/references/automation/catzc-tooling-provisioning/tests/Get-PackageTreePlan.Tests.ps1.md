---
catzc:
  immutable:
    with_body_sha: "06247398c1a5"
    path: docs/references/automation/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning/tests
    name: get-package-tree-plan-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-PackageTreePlan' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-PackageTreePlan over two fixture trees in $TestDrive. It reads the filesystem only. Neutral fixture names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

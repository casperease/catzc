---
catzc:
  immutable:
    with_body_sha: "16147d2960ae"
    path: docs/references/automation/catzc-base-qualitygates/tests/Get-NeutralCodeFinding.Tests.ps1.md
    folder: docs/references/automation/catzc-base-qualitygates/tests
    name: get-neutral-code-finding-tests-ps1
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

# automation/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-NeutralCodeFinding' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-NeutralCodeFinding over fixture test files: ADR-WIDGET-GADGET stands in for a code the ADR registry declares,
and ADR-WIDGET-SPROCKET for a neutral one
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

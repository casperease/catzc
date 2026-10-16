---
catzc:
  immutable:
    with_body_sha: bac7aa50fcf4
    repo_status: locked
    path: docs/references/automation/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md
    folder: docs/references/automation/catzc-base-docs/tests
    name: get-glossary-sources-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-TEST#3
      - ADR-PWSH-PESTER#4
---

# automation/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-GlossarySources' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-GlossarySources is private, so it is exercised through the module (InModuleScope, per
[ADR-PWSH-PESTER#4](/docs/adr/pwsh/pester-testing.md#rule-adr-pwsh-pester4)).
Discovery is redirected to the fixture sources under tests/assets/glossary/ through the Resolve-ConfigEntry seam,
so every source still loads through Get-Config and the GlossaryConfig type; git is mocked at Get-GitTrackedPath.
The fixture owners are loaded modules (Get-Config resolves validation in the owner's scope); the fixture terms
are neutral (widget/gadget, [ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

---
catzc:
  immutable:
    with_body_sha: bea29323a999
    repo_status: locked
    path: docs/references/automation/catzc-base-contracts/tests/types/ContractsConfig.Tests.ps1.md
    folder: docs/references/automation/catzc-base-contracts/tests/types
    name: contracts-config-tests-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
---

# automation/Catzc.Base.Contracts/tests/types/ContractsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'ContractsConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
ContractsConfig maps contracts.yml and is the one declaration of its sensible defaults
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted key behaves exactly
like the default, a declared but unbuilt addressing mode is a valid value, and anything else fails at construction.
```

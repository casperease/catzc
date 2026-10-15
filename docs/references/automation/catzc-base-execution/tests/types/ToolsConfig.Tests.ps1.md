---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: c697df88f81e
    adrs:
      - ADR-AUTO-TEST#14
      - ADR-AUTO-TEST#3
---

# automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Context 'integrity (shipped tools.yml)' -Tag 'integrity' {`.

```text
Reads the shipped tools.yml — guards real repository content
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```

## comment:2

Above `Context 'logic (inline configs)' -Tag 'logic' {`.

```text
Constructor logic on an inline (synthetic) config — independent of any shipped asset
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The rule keys on the literal
`python` tool (the pinned interpreter); every other tool is a fixture token
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

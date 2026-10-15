---
catzc:
  derived:
    path: docs/references/automation/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
    kind: comment-page
    body_sha: "2c3e915007f1"
    adrs:
      - ADR-AUTO-TEST#{3,14}
---

# automation/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Context 'integrity (shipped tools.yml)' -Tag 'integrity' {`, written with `#`.

```text
Reads the shipped tools.yml — guards real repository content
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)).
```

## comment:2

Above `Context 'logic (inline configs)' -Tag 'logic' {`, written with `#`.

```text
Constructor logic on an inline (synthetic) config — independent of any shipped asset
([ADR-AUTO-TEST#14](/docs/adr/automation/test-automation.md#rule-adr-auto-test14)). The rule keys on the literal
`python` tool (the pinned interpreter); every other tool is a fixture token
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
    kind: test-asset
    body_sha: "5abcfcc8baac"
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-FLOW-CD-GLOBS#4
      - ADR-FLOW-CD-GLOBS#7
      - ADR-FLOW-CD-GLOBS#8
---

# automation/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1

<!-- cspell:ignore dedupe -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per
section (Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'GlobsConfig' -Tag 'L0', 'logic' {`.

```text
The globs.yml registry guard: strict shape (unknown keys rejected), every entry a valid GlobSet with a
layer declared ([ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7)), and compose
resolving acyclically to declared sets
([ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)).
```

## comment:2

Above `$script:program = {`.

```text
Render a set's flattened scan program as '+ pattern' / '- pattern' lines
([ADR-FLOW-CD-GLOBS#4](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4)/8) — the
ordered membership program, the durable behaviour the removed marker rendering used to show.
```

## comment:3

Above `$c = & $script:make @{`.

```text
Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
```

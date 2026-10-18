# pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1

<!-- cspell:ignore dedupe -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobsConfig' -Tag 'L0', 'logic' {`, written with `#`.

```text
The globs.yml registry guard: strict shape (unknown keys rejected), every entry a valid GlobSet with a
layer declared ([ADR-FLOW-CD-GLOBS-EVERYSETHASLAYER](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-everysethaslayer)), and compose
resolving acyclically to declared sets
([ADR-FLOW-CD-GLOBS-COMPOSESETS](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-composesets)).
```

## comment:2

Above `$script:program = {`, written with `#`.

```text
Render a set's flattened scan program as '+ pattern' / '- pattern' lines
([ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs-trackedfilesonly)/8) — the
ordered membership program, the durable behaviour the removed marker rendering used to show.
```

## comment:3

Above `$c = & $script:make @{`, written with `#`.

```text
Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

# pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1

<!-- cspell:ignore dedupe -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'GlobsConfig'`, written with `#`.

```text
The globs.yml registry guard: strict shape (unknown keys rejected), every entry a valid GlobSet with a
layer declared ([FDR-CD-GLOBS-EVERYSETHASLAYER](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-everysethaslayer)), and compose
resolving acyclically to declared sets
([FDR-CD-GLOBS-COMPOSESETS](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-composesets)).
```

## comment:2

Above `$script:program = {`, written with `#`.

```text
Render a set's flattened scan program as '+ pattern' / '- pattern' lines
([FDR-CD-GLOBS-TRACKEDFILESONLY](/docs/drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)/8) — the
ordered membership program, the durable behaviour the removed marker rendering used to show.
```

## comment:3

Above `$c = & $script:make @{`, written with `#`.

```text
Neutral fixture globset names (widget/gadget), not the real loose-fileset/deployable-unit names
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](/docs/drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).
```

## comment:4

Above `(& $script:program $c.Get('top')) | Should -Be @('+ mid/**', '+ leaf/**', '+...`, written with `#`.

```text
top composes [mid, leaf]; mid already pulls leaf. Raw: +leaf,+mid,+leaf,+top -> dedupe-last:
+mid,+leaf,+top
```

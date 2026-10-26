# pwsh/Base.Globs/tests/types/GlobsConfig.Tests.ps1

<!-- cspell:ignore dedupe -->

The tests of `GlobsConfig`, the guard of the `globs.yml` registry.

## What it proves

The shape is strict, so unknown keys are rejected. Every entry is a valid `GlobSet` with a layer set
([FDR-GLOBS-EVERYSETHASLAYER](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-everysethaslayer)), and compose resolves
acyclically to declared sets ([FDR-GLOBS-COMPOSESETS](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-composesets)).

## The scan program

The tests render a set's flattened scan program as `+ pattern` and `- pattern` lines
([FDR-GLOBS-TRACKEDFILESONLY](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)/8), the ordered membership
program. One case has `top` composing `[mid, leaf]` while `mid` already pulls `leaf`: the raw program is `+leaf, +mid, +leaf, +top`, and
deduplicating on the last occurrence gives `+mid, +leaf, +top`.

## Fixtures

The fixture globset names are neutral (widget, gadget), not the real loose-fileset and deployable-unit names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

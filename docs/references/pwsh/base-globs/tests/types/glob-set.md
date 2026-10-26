# pwsh/Base.Globs/tests/types/GlobSet.Tests.ps1

The tests of the `GlobSet` record.

## What it proves

Membership is decided by the scan program, an ordered `+`/`-` rule list where the last match wins
([FDR-GLOBS-TRACKEDFILESONLY](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-trackedfilesonly)). It is flattened through
compose with the own rules last ([FDR-GLOBS-COMPOSESETS](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-composesets)). The
constructor guards the shape: a kebab-case name, a required description, a layer set, an include or compose present, and no duplicate
patterns.

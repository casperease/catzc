# pwsh/Base.Globs/tests/types/GlobSet.Tests.ps1

The tests of the `GlobSet` record.

## What it proves

Membership is decided by the scan program, an ordered `+`/`-` rule list where the last match wins
([FDR-CD-GLOBS-TRACKEDFILESONLY](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-trackedfilesonly)). It is flattened through
compose with the own rules last ([FDR-CD-GLOBS-COMPOSESETS](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-composesets)).
The constructor guards the shape: a kebab-case name, a required description, a layer set, an include or compose present, and no duplicate
patterns.

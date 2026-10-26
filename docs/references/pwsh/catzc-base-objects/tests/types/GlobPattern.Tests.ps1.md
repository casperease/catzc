# pwsh/Base.Objects/tests/types/GlobPattern.Tests.ps1

The L0 logic tests of `GlobPattern`, one glob of the durable-sha-globs dialect.

## What it proves

The tests hold the dialect's truth table
([FDR-CD-GLOBS-REPOSITORYRELATIVEPATTERNS](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-repositoryrelativepatterns)) and the
constructor guard
([FDR-CD-GLOBS-MALFORMEDPATTERNREJECTED](../../../../../drs/flow/durable-sha-globs.md#rule-fdr-cd-globs-malformedpatternrejected)):
per-segment PowerShell wildcards, `**` as the only cross-segment operator (zero or more whole segments), case-sensitive matching, and a
malformed pattern that never produces an instance.

# pwsh/Base.QualityGates/tests/Test-Formatting.Tests.ps1

The test of `Test-Formatting`, a quality gate
([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)).

## Logic

Each L0 case mocks the registry and `Format-Code` at the module boundary and reads the collected issues. The report goes to `$TestDrive`.
The fixtures use neutral names
([ADR-AUTO-TEST-DISTINCTFIXTURES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtures)).

## Integrity

The integrity block proves that the real repository is formatted: every language in `languages.yml` has a formatter, and the C# type
namespaces hold, where each source declares its module's file-scoped namespace, the invariant that the type loader also enforces. It is L2
because it drives the real engines, and it self-skips when one of their tools is absent
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)). It is
source-only, because it reads the repository's own files, which give the same answer in both run modes.

It is greedy ([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)): on a
cold format cache it runs every formatter over the whole tree, the psscriptanalyzer engine in its own background jobs, so it consumes the
machine beyond its own process. In a parallel shard it held that shard past the run's time roof; in the greedy phase its file is a shard of
its own, started by its measured duration beside the parallel shards.

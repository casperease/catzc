# pwsh/Base.Globs/tests/Get-PipelineTrigger.Tests.ps1

The tests of `Get-PipelineTrigger`, the reader of a pipeline or workflow YAML's actual trigger path filters
([FDR-GLOBS-NAMEDGLOBSETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-namedglobsets)).

## What it proves

It reads the on-disk side that the drift quality gate compares against the computed projection.

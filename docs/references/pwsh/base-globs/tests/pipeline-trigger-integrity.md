# pwsh/Base.Globs/tests/PipelineTrigger-Integrity.Tests.ps1

The integrity test of the pipeline triggers: the drift quality gates run over this repository's real pipeline files
([FDR-GLOBS-NAMEDGLOBSETS](../../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-namedglobsets)).

## What it proves

Every pipeline-bound globset's Azure DevOps pipeline, and the GitHub CI workflow, declares the trigger path filters its projection computes.
A source-path filter hand-edited out of sync with `globs.yml` fails here.

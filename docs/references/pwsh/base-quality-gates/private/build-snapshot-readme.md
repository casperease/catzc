# pwsh/Base.QualityGates/private/Build-SnapshotReadme.ps1

Builds the gitignored generated README files of a test-run snapshot once, before any of its workers starts, so the snapshot carries them as
a working tree does.

## help

### synopsis

Builds the generated README files of a test-run snapshot once, before its workers start.

### description

A snapshot (New-RepositorySnapshot) carries only the tracked and untracked files of the working tree, never the gitignored generated
READMEs. Its workers import with -SkipJanitors, so none of them writes those files; this writes them once, after the priming import
(Enter-TestRunLocation) and before any worker starts.

It starts one pwsh process in the snapshot, non-interactive with the arguments the engine model gives pwsh
([ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce)),
which dot-sources the snapshot's own importer with -SkipJanitors and runs Build-Readme -Silent. A non-zero exit throws with the last ten
lines of the process's output.

### parameter `SnapshotRoot`

The snapshot's root folder, as a full path.

## comment:1

Above `$pwshEngine = [Catzc.Base.Engines.ExecutionEngines]::Pwsh`, written with `#`.

```text
The snapshot's workers import with -SkipJanitors, so the gitignored generated READMEs are written once here, as a
working tree has them, before any worker starts.
```

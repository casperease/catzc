# pwsh/Base.GeneratedFiles/configs/generated-files.yml

The one list of generated-file writers: what each reads and writes, and the order the import re-renders them in. It is the single place a
writer's dependencies are declared, read by `Get-GeneratedWriterDue` and `Test-GeneratedFiles`.

## The writers

`Test-GeneratedFiles` runs the writers report-only ([ADR-AUTO-TEST-QUALITYGATE](../../../../drs/automation/test-automation.md)); a file
result names its stale file in the property `result_path` (default `Path`). The generators of the managed root files are the generator
keys of `rootconfig.yml`, so they are never listed here.

A writer with `at_import: true` is re-rendered by the import when its lists make it due, in the order of this file (default: false); the
importer holds no writer list of its own.

## Inputs and outputs

Both are optional lists of repository-relative globs (default: none): what a writer reads and what it writes. With `-Changed` a writer's
dry run runs when a changed path matches one of them, and a writer with neither list runs whenever anything changed.

`Build-RootConfig` lists its generators, its sources (the `source` and `sources` of `rootconfig.yml`) and its targets as inputs, and no
outputs, since its generators live in several modules and its output set is every opted-in root file. A drifted target, ignored or not, is
an input change, so the run that writes it back is due.

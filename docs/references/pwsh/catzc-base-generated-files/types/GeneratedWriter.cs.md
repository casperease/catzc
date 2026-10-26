# pwsh/Base.GeneratedFiles/types/GeneratedWriter.cs

The typed record for one entry of `writers` in `generated-files.yml`, one generated-file writer that `Test-GeneratedFiles` runs report-only.
Every default is declared here once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

## Properties

- **`name`** — the writer's command name, a Verb-Noun.
- **`check`** — how the writer is checked, which tells the drift check which report shape the writer's `-PassThru` result has. Default
  `file`:
  - `file`: one result per file, with a path property;
  - `english-dictionary`: the committed list against its stamp;
  - `root-config`: the managed root files, each attributed to the generator the root-config registry names;
  - `none`: the writer's output is scratch under `out/`, so only its stamp decides whether it runs and no drift check reads it.
- **`result_path`** — the property of a file result that holds the stale file's path. Default `Path`; null for a check other than `file`,
  and setting it for one is rejected.
- **`inputs`** and **`outputs`** — repository-relative globs of what the writer reads and writes; a changed path matching one makes
  `-Changed` run its dry run. Default none.
- **`at_import`** — whether the import re-renders the writer when it is due (the build janitors). Default false.

## Validation

Constructing the record gathers every violation into one `ArgumentException`: the name must be a Verb-Noun command name, the entry must be a
map, only the known keys are allowed, and `check` must be one of the four above.

# pwsh/Base.QualityGates/private/Get-TestDurationHistory.ps1

Reads the per-file test durations the last runs measured on this machine. The history is `durations.json` beside the run folders under
`out/`, gitignored, and it feeds the assignment of files to shards.

## help

### synopsis

Reads the per-file test durations the last runs measured on this machine.

### description

The history is a per-machine file, durations.json, beside the run folders under out/ (gitignored, never committed): repository-relative
'/'-separated test file path -> milliseconds, the file's whole Pester duration including its set-up. Select-TestShardAssignment schedules
from it. A missing or unreadable history is an empty one: the run falls back to an even split and writes a fresh history at its end.

### parameter `Path`

The history file.

### outputs

`[hashtable]` File path -> milliseconds.

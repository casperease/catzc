# pwsh/Base.QualityGates/private/Save-TestDurationHistory.ps1

Merges a run's measured per-file durations into the test duration history. Files the run did not measure keep their entries, so a partial
run forgets nothing.

## help

### synopsis

Merges a run's measured per-file durations into the test duration history.

### description

Files this run did not measure keep their entries, so a partial run (one module, one tier) forgets nothing. A faster run lowers Each file
the run measured replaces its entry; files the run did not run keep theirs, so a partial run (one module, one tier) never forgets the rest.
The file is written sorted by path, so it diffs cleanly, and written only after the run's own results are safe, so a crash cannot corrupt
it. See Get-TestDurationHistory.

### parameter `Path`

The history file.

### parameter `DurationMs`

This run's measurements, repository-relative '/'-separated file path -> milliseconds.

### parameter `Decay`

The share of the stored duration a faster run keeps (0 up to, not including, 1); omitted reads duration_decay from test-policy.yml.

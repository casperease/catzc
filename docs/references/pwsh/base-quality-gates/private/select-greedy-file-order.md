# pwsh/Base.QualityGates/private/Select-GreedyFileOrder.ps1

Orders a run's greedy test files for the pool: the files `greedy_apart` names first, since they run one at a time and their chain is the
pool's critical path, then every unmeasured file, then the rest by their measured duration, longest first
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).

## help

### synopsis

Orders a run's greedy test files: the apart files first, then the unmeasured, then the rest longest first.

### description

The pool starts greedy files in submission order as slots free, and of the files `greedy_apart` names only one runs at a time, so that chain
decides when the greedy phase ends and goes first, longest first within it. An unmeasured file goes before every measured one: sorted last
it would never start in a run that overruns, and so never be measured. The measured files follow by duration, longest first
(Get-TestDurationHistory), and a tie keeps the file path order, so the result is deterministic.

### parameter `File`

The greedy test files, absolute paths.

### parameter `DurationMs`

The known durations, repository-relative '/'-separated file path -> milliseconds.

### parameter `RepositoryRoot`

The root the history's paths are relative to.

### parameter `Policy`

The test policy, whose `greedy_apart` names the files that run one at a time.

### outputs

`[string[]]` The files in the order the pool submits them.

# pwsh/Base.QualityGates/private/Select-ProtectedTestFile.ps1

The protection decision: it drops the test files of every unit whose composite identity is unchanged since its last green run this session.
It groups the run's files by unit and composes each unit's protection identity.

## help

### synopsis

The protection decision: drops the test files of every unit whose composite identity is unchanged since its last green run this session.

### description

Groups the run's test files by unit (Get-TestFileModule), composes each unit's protection identity (Get-ModuleProtectionIdentity — own set +
declared closure + infra + runner, widened for integrity tests and unconstrained modules), and queries the session map. Protected units'
files are removed from the returned work-lists; unprotected units are returned as candidates for Protect-TestedModule after a green run. In
a pipeline this returns the input unchanged without computing a single identity — CI pays nothing and skips nothing.

It rests on
[ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-orchestratordecides).

### parameter `ParallelFiles`

The parallel-phase test files.

### parameter `GreedyFiles`

The greedy-phase test files.

### parameter `SerialFiles`

The serial-phase test files.

### parameter `Discovery`

The run's discovery-only Pester result — used to find which units carry integrity-tagged tests.

### parameter `ProtectionKey`

The run-parameter key ('`test-automation|L<min>-L<max>|<category>`').

### outputs

`[pscustomobject]` with ParallelFiles, GreedyFiles, SerialFiles (the work-lists minus protected units' files), ProtectedModules, and
Candidates (units to promote when they come back green).

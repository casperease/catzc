# pwsh/Base.QualityGates/private/Get-TestRunWorkerEnvironment.ps1

Builds the environment each test worker process starts with. It carries the tripwire that makes a real process launch inside a unit-level
run fail, so a missed mock is found where it happens.

## help

### synopsis

The environment variables a test worker is started with, chosen by the highest tier of the run.

### description

A run whose highest tier stays below the first tier that may start real processes blocks every launch; a run that reaches that tier blocks
by tier. The value comes from the compiled test-tier type, so the worker and the guard agree on one spelling.

### parameter `MaxLevel`

The highest test tier in the run's scope.

### outputs

`[hashtable]` with the single key `CATZC_BLOCK_REAL_PROCESS`, holding the block mode.

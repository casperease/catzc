# pwsh/Base.QualityGates/private/Protect-TestedModule.ps1

Promotes protection for every candidate unit that came back green from a Test-Automation run. It attributes the aggregated result rows to
each unit, so a later run can skip a unit whose protection identity is unchanged.

## help

### synopsis

Promotes protection for every candidate unit that came back green from a Test-Automation run.

### description

Per-module attribution over the aggregated rows
([ADR-REPO-PROTGLOB-ORCHESTRATORDECIDES](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-orchestratordecides)): a unit
is promoted exactly when it produced at least one row and none of its rows failed. The rows-present guard is what makes a
failed-but-completed shard safe to attribute around: a worker exits 1 when it CONTAINS failing tests (their rows name their files
precisely), while a unit whose shard died before producing rows yields no rows and is never promoted. Two cases promote nothing at all: a
failed shard with zero failed rows anywhere (a container/discovery error — nothing is attributable) and a failed row with no file. The
identity promoted is the pending pre-run value
([ADR-REPO-PROTGLOB-PROTECTIONKEY](../../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-protectionkey)); in a pipeline
Protect-GlobSet is a no-op anyway.

### parameter `Candidates`

The units Select-ProtectedTestFile queried and found unprotected — the only ones with a pending identity.

### parameter `Rows`

The run's aggregated per-test rows.

### parameter `FailedShardLabels`

Labels of worker shards that exited 1.

### parameter `ProtectionKey`

The run-parameter key the candidates were queried under.

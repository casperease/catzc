# pwsh/Catzc.Base.QualityGates/private/Protect-TestedModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Promotes protection for every candidate unit that came back green from a Test-Automation run.

### description

Per-module attribution over the aggregated rows
([ADR-REPO-PROTGLOB#9](../../../../adr/repository/protected-globs.md#rule-adr-repo-protglob9)): a unit is promoted exactly when it produced
at least one row and none of its rows failed. The rows-present guard is what makes a failed-but-completed shard safe to attribute around: a
worker exits 1 when it CONTAINS failing tests (their rows name their files precisely), while a unit whose shard died before producing rows
yields no rows and is never promoted. Two cases promote nothing at all: a failed shard with zero failed rows anywhere (a container/discovery
error — nothing is attributable) and a failed row with no file. The identity promoted is the pending pre-run value
([ADR-REPO-PROTGLOB#4](../../../../adr/repository/protected-globs.md#rule-adr-repo-protglob4)); in a pipeline Protect-GlobSet is a no-op
anyway.

### parameter `Candidates`

The units Select-ProtectedTestFile queried and found unprotected — the only ones with a pending identity.

### parameter `Rows`

The run's aggregated per-test rows.

### parameter `FailedShardLabels`

Labels of worker shards that exited 1.

### parameter `ProtectionKey`

The run-parameter key the candidates were queried under.

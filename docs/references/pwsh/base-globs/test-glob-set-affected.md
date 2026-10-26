# pwsh/Base.Globs/Test-GlobSetAffected.ps1

The in-pipeline check of a deployable unit: it says whether the current change touches the unit's globset, and fails open on any doubt
([ADR-REPO-PROTGLOB-FAILOPEN](../../../drs/repository/protected-globs.md#rule-adr-repo-protglob-failopen)).

## help

### synopsis

Returns whether the current context's change touches a globset, the in-pipeline check for anything to process.

### description

The boolean a deployable unit's pipeline stage checks to stop early ("nothing for us; return") when its own area of control is untouched by
the change. It reflects the context's diff (Get-GlobSetChangeRange, then Get-ChangedGlobSet) and reports whether the named set is among
those touched. Because the range is resolved from real refs at run time
([FDR-GLOBS-CHANGECOMPUTEDFROMGIT](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-changecomputedfromgit)), this check is immune to
the squash-merge and concurrent-merge staleness a committed marker hash suffers.

Fail-open ([FDR-GLOBS-CHANGECOMPUTEDFROMGIT](../../../drs/flow/durable-sha-globs.md#rule-fdr-globs-changecomputedfromgit)): when the
reference commit cannot be resolved or the diff cannot be computed — a shallow clone that cannot reach the base, an unresolved PR target
ref, a first commit with no parent — this returns
$true, proceed. A redundant run is safe; a wrong skip is an un-deployed change. It returns
$false ONLY when it has positively confirmed, over
a resolvable range, that the set is untouched. An undeclared name is a programming error, not a runtime ambiguity, so it throws (fail-fast,
[ADR-AUTO-FAILFAST](../../../drs/automation/fail-fast-with-asserts.md)) rather than silently reporting "not affected" and skipping.

### parameter `Name`

The globset — typically a deployable unit — to test.

### outputs

`[bool]` $true when the set is affected (or the range is indeterminate — fail-open); $false only when the set is confirmed untouched.

### example 1

```powershell
if (-not (Test-GlobSetAffected -Name apex)) { return }
```

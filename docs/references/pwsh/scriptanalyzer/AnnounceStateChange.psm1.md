# pwsh/.scriptanalyzer/AnnounceStateChange.psm1

The custom analyzer check module for state changes: a function that changes the session's state must announce it, and persistent
environment and registry writes go only through their seams.

## Announcing a change

`Measure-AnnounceStateChange` requires that a writer runs together with the change it announces. It checks that a writer is there, not what
its line says; the wording stays a review concern.

Three helpers read the call being checked:

- The argument of a command's named parameter (`-Name value` or `-Name:value`) is read first; failing that, the first positional argument,
  the element straight after the command name when that is not a parameter.
- A node inside a scriptblock handed literally to a job or a parallel `ForEach-Object` is not counted with the surrounding function, since
  that block runs in another runspace or process.
- Every change is grouped by its scope. For each scope the check notes which targets a `finally` block restores and which blocks an
  information-stream writer call covers.

## Persistent writes

`Measure-PersistentWriteThroughSeam` sends persistent environment and registry writes through one mockable seam, so only that seam's own
test touches real state.

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).

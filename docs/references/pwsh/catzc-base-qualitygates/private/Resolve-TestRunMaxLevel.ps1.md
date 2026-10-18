# pwsh/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Resolves the highest tier a test run executes, from the location it runs in.

### description

L3 holds the vertical system tests: they change or depend on state outside the repository — the cloud, the user's environment, installed
tools ([ADR-AUTO-TEST-SYSTEMTESTSATLTHREE](../../../../adr/automation/test-automation.md#rule-adr-auto-test-systemtestsatlthree)). A
snapshot isolates a run from the working folder, never from that outside state, so only the run that owns the working folder (the in-place
location) runs L3 — and since that state belongs to the user, not to one checkout, only while it also holds the user's system-test lock
(Enter-SystemTestLock). Two concurrent runs — from one checkout or from two — never both execute system tests against the same user's state,
and nobody waits.

In place with the system-test lock, the requested level stands (both runs ask for 3 unless the caller bound a lower -MaxLevel). Otherwise —
in a snapshot, or in place while another run on this account holds the system-test lock — a request that reaches L3 is capped at L2, and the
cap is announced: the run says it skips L3 and who holds the working folder or the lock, so a missing tier is never silent
([ADR-AUTO-CONSOLE-ANNOUNCEBEFOREBLOCKING](../../../../adr/automation/console-output-matters.md#rule-adr-auto-console-announcebeforeblocking)).
L4, the opt-in tier that tests the released system after final approval
([ADR-AUTO-TEST-TESTINGINPRODUCTION](../../../../adr/automation/test-automation.md#rule-adr-auto-test-testinginproduction)), runs only when
asked for, and where L3 runs: a run capped at L2 skips L4 too, and says so.

### parameter `Location`

The location Enter-TestRunLocation returned.

### parameter `Requested`

The highest tier the caller asks for. Default 3 (TestTiers.DefaultTop): every tier the location allows, L4 excluded; 4 includes L4.

### parameter `MinLevel`

The lowest tier the caller asks for. A run that asks only for tiers its location skips (L3 in a snapshot, or without the system-test lock)
has nothing to run, so it throws, naming why.

### outputs

`[int]` the highest tier to run.

### example 1

```powershell
$maxLevel = Resolve-TestRunMaxLevel -Location $location
```

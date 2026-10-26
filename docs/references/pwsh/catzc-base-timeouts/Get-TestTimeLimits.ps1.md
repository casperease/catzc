# pwsh/Base.Timeouts/Get-TestTimeLimits.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the test-run time limits: the most one test of each tier may take, and the budget for a whole run.

### description

Reads the `tests` section of timeouts.yml (TimeoutsConfig), defaults filled in, so Test-Automation's timing report and its run-budget check
read one source instead of a literal of their own
([ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait)). LevelMs is
keyed by tier tag (`[Catzc.Base.Timeouts.TestTiers]::Names`, L0 to L4) in milliseconds; RunSeconds is the budget for a whole Test-Automation
run up to L3 (an L4 run is a stage of its own).

### outputs

`[pscustomobject]` with LevelMs (`[hashtable]`) and RunSeconds (`[int]`).

### example 1

```powershell
(Get-TestTimeLimits).LevelMs['L2']   # the most milliseconds one L2 test may take
```

### example 2

```powershell
(Get-TestTimeLimits).RunSeconds      # the budget for a whole run
```

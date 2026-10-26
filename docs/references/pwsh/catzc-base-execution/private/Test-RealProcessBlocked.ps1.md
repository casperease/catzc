# pwsh/Base.Execution/private/Test-RealProcessBlocked.ps1

The decision behind the real-process tripwire of `Invoke-Executable`: it says whether a launch is forbidden at this point of a test run.

## help

### synopsis

Says whether a real process launch is forbidden at this point of a test run.

### description

Reads CATZC_BLOCK_REAL_PROCESS, which a test run sets on its workers' environment. Unset: nothing is forbidden. `1`: every launch is
forbidden. `tier`: a launch is forbidden only inside a Describe whose outermost tag is a tier below the first that may launch a process (L0
and L1), found through Pester's current block, so the L2 and higher containers of the same worker still drive real tools. Any other value
throws, naming it. The two values and the tiers are declared once, on TestTiers (Catzc.Base.Timeouts), and the run reads the same ones.
Invoke-Executable asks it before every launch
([ADR-AUTO-TEST-PROCESSTRIPWIRE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-processtripwire)).

### outputs

`[bool]` True when the launch must throw.

## Armed per container

Only the L0 and L1 Describes of a run forbid a real process. The check asks Pester's current block where the call comes from, so the L2 and
higher containers of the same worker still drive real tools. Outside any Describe, such as a script's top level or a stray module call,
nothing is armed.

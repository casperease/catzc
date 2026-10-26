# pwsh/Base.Timeouts/Invoke-WithTimeout.ps1

The time safeguard for a script block: it runs the block in the current runspace under a watchdog and throws a timeout error when the
block outlives its limit.

## help

### synopsis

Runs a script block inside a time safeguard: past its limit it is stopped and the call throws.

### description

Runs the script block in the current runspace — it sees the same functions, modules and variables it would see when called directly — and
returns its output. A PipelineWatchdog stops it once it outlives the limit, including a native command it is waiting on; the call then
throws a TimeoutException that names the limit and where it comes from. A terminating error inside the block is rethrown as itself;
non-terminating errors are passed on as errors of this call.

### parameter `ScriptBlock`

The work to run.

### parameter `Budget`

The work's immutable budget GUID (registered in the managed-GUID registry). While timeout-exemptions.yml exempts it, the default limit is
the exemption ceiling instead.

### parameter `Seconds`

The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption ceiling (Get-TimeoutSeconds
-Budget).

### parameter `Activity`

What the work is, for the timeout message. Defaults to the script block's text.

### example 1

```powershell
$tree = Invoke-WithTimeout { Get-ChildPath $root -Depth 3 } -Seconds 30
```

### example 2

```powershell
Invoke-WithTimeout { Sync-Widget } -Activity 'widget sync'
```

### example 3

```powershell
Invoke-WithTimeout { Sync-Widget } -Budget $widgetSyncBudget
```

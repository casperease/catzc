# pwsh/Base.Timeouts/Assert-CompletesWithin.ps1

The assertion form of the time safeguard for a script block: the work runs under a limit and the call throws if the work is stopped at it.

## help

### synopsis

Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.

### description

The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass (it finished in time) or throw (it
was stopped at the limit, or it failed on its own).

### parameter `ScriptBlock`

The work to time.

### parameter `Budget`

The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption ceiling instead.

### parameter `Seconds`

The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption ceiling (Get-TimeoutSeconds
-Budget).

### parameter `Activity`

What the work is, for the timeout message. Defaults to the script block's text.

### example 1

```powershell
Assert-CompletesWithin { Import-Widget } -Seconds 2
```

### example 2

```powershell
Assert-CompletesWithin { Sync-Widget } -Budget $widgetSyncBudget
```

# pwsh/Base.Timeouts/Test-CompletesWithin.ps1

The boolean form of the script-block time safeguard: it answers whether the work finished within its limit.

## help

### synopsis

Tests whether a script block finishes within a time limit; past it the work is stopped.

### description

The boolean form of Assert-CompletesWithin: $true when the block finished in time, $false when the safeguard stopped it at the limit. The
block's output is discarded. An error the block raises on its own is not a timeout, so it still throws — this answers "was it fast enough",
never "did it succeed".

### parameter `ScriptBlock`

The work to time.

### parameter `Budget`

The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption ceiling instead.

### parameter `Seconds`

The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption ceiling (Get-TimeoutSeconds
-Budget).

### example 1

```powershell
if (-not (Test-CompletesWithin { Get-Widget } -Seconds 2)) { Write-Message 'widget lookup is slow' }
```

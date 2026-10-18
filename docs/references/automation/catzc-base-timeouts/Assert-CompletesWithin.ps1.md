# automation/Catzc.Base.Timeouts/Assert-CompletesWithin.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Asserts that a script block finishes within a time limit; past it the work is stopped and the assert throws.

### description

The assertion form of Invoke-WithTimeout: the block's output is discarded, and the only outcome is pass
(it finished in time) or throw (it was stopped at the limit, or it failed on its own).

### parameter ScriptBlock

The work to time.

### parameter Budget

The work's immutable budget GUID. While timeout-exemptions.yml exempts it, the default limit is the exemption
ceiling instead.

### parameter Seconds

The limit in seconds. Defaults to the run environment's pwsh limit in timeouts.yml, or the budget's exemption
ceiling (Get-TimeoutSeconds -Budget).

### parameter Activity

What the work is, for the timeout message. Defaults to the script block's text.

### example 1

```powershell
Assert-CompletesWithin { Import-Widget } -Seconds 2
```

### example 2

```powershell
Assert-CompletesWithin { Sync-Widget } -Budget $widgetSyncBudget
```

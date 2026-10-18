# automation/Catzc.Base.Timeouts/Test-IsTimeoutExempt.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Tests whether a budget GUID is exempt from its normal time limit in this run environment.

### description

The boolean form of Get-TimeoutExemption, which defines the lookup.

### parameter Budget

The budget's immutable GUID.

### parameter Shell

The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.

### example 1

```powershell
if (Test-IsTimeoutExempt $budget) { Write-Message 'running exempt while tuned' }
```

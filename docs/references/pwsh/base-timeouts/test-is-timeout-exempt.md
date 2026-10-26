# pwsh/Base.Timeouts/Test-IsTimeoutExempt.ps1

The boolean form of the timeout exemption lookup: it answers whether a budget GUID is exempt in this run environment.

## help

### synopsis

Tests whether a budget GUID is exempt from its normal time limit in this run environment.

### description

The boolean form of Get-TimeoutExemption, which defines the lookup.

### parameter `Budget`

The budget's immutable GUID.

### parameter `Shell`

The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.

### example 1

```powershell
if (Test-IsTimeoutExempt $budget) { Write-Message 'running exempt while tuned' }
```

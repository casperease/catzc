# pwsh/Base.Timeouts/Assert-IsNotTimeoutExempt.ps1

The guard for work that must never run exempt: it throws, naming the reason, when a budget has a timeout exemption in this run environment.

## help

### synopsis

Asserts that a budget GUID runs under its normal time limit here, not an exemption.

### description

For work that must never run exempt — for example a quality gate in a pipeline, where an exemption would hide a regression. Throws naming
the exemption's reason when the budget is exempt; Get-TimeoutExemption defines the lookup.

### parameter `Budget`

The budget's immutable GUID.

### parameter `Shell`

The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default.

### example 1

```powershell
if (Test-IsRunningInPipeline) { Assert-IsNotTimeoutExempt $budget }
```

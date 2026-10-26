# pwsh/Base.Timeouts/Assert-IsNotTimeoutExempt.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

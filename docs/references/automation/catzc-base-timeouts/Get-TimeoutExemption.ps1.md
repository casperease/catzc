# automation/Catzc.Base.Timeouts/Get-TimeoutExemption.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the exemption that covers a budget GUID in this run environment, or nothing.

### description

Looks the budget up in timeout-exemptions.yml for the run environment (Get-RunEnvironment) and shell. An exemption raises the budget's limit
to its scope's ceiling while the work is tuned; it never removes the limit. The result is the normalized entry: kind (single | range), from,
to, environments, shells, reason.

### parameter `Budget`

The budget's immutable GUID — registered in the managed-GUID registry and passed by the call site.

### parameter `Shell`

The shell the work runs in, one of the execution engines (pwsh, bash or zsh); pwsh is the default. Any other name throws, naming the shells.

### parameter `EnvironmentAssertIs`

Pins the expected run environment (Pipeline or Devbox); a different one throws. The guard verifies, it never selects.

### outputs

`[hashtable]` The covering exemption; nothing when the budget is not exempt here.

### example 1

```powershell
Get-TimeoutExemption $budget
```

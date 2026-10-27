# pwsh/Azure.DevOps/Test-AdoServiceConnections.ps1

The gate that checks the project's Azure service connections against `service-connections.yml`: no connection holds a stored credential.

## help

### synopsis

Reports every Azure service connection that is not federated, not declared, or declared but missing.

### description

Lists the project's azurerm service connections and reports, as quality-gate issues: a connection that authenticates by anything other
than workload identity federation, which means it holds a stored credential; a connection the config does not declare; and a declared
connection the project lacks. It reads Azure DevOps and changes nothing; `Sync-AdoServiceConnections` is the fix for each finding.

### parameter `Project`

The Azure DevOps project. Default: ado.yml's project.

### parameter `Organization`

The organization URL, `https://dev.azure.com/<org>`. Default: ado.yml's organization.

### parameter `OutputFolder`

The folder for the gate's report. Default: the gate's own folder under out/.

### parameter `PassThru`

Returns the result instead of throwing on an issue.

### example 1

```powershell
Test-AdoServiceConnections
```

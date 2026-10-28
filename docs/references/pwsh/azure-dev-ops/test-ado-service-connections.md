# pwsh/Azure.DevOps/Test-AdoServiceConnections.ps1

The gate that checks the project's Azure service connections against the given connections, such as those `Get-BicepServiceConnections`
derives from `service-connections.yml`: no connection holds a stored credential.

## help

### synopsis

Reports every Azure service connection that is not federated, not given, or given but missing.

### description

Takes the expected connections from the pipeline or `-Connection`, lists the project's azurerm service connections and reports, as
quality-gate issues: a connection that authenticates by anything other than workload identity federation, which means it holds a stored
credential; a connection the input does not hold; and a given connection the project lacks. It reads Azure DevOps and changes nothing;
`Sync-AdoServiceConnections` is the fix for each finding.

### parameter `Connection`

The expected connections, each with its name, as `Get-BicepServiceConnections` lists them. Takes pipeline input.

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
Get-BicepServiceConnections | Test-AdoServiceConnections
```

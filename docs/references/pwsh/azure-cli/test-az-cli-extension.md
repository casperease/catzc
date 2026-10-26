# pwsh/Azure.Cli/Test-AzCliExtension.ps1

The query twin of the extension assertion: it returns a bool for whether a named Azure CLI extension is installed.

## help

### synopsis

Tests whether an Azure CLI extension is installed.

### description

Returns $true if the named extension is installed, $false otherwise. Uses `az extension show` (a core command) and inspects the exit code,
so it never throws on a missing extension and never triggers a dynamic install. Companion to Assert-AzCliExtension, mirroring the
Test-/Assert-AzCliConnected pair.

### parameter `Name`

The extension name (e.g. 'ip-group').

### outputs

System.Boolean

### example 1

```powershell
if (Test-AzCliExtension 'ip-group') { '...installed' }
```

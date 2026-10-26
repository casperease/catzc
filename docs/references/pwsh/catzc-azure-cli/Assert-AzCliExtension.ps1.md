# pwsh/Azure.Cli/Assert-AzCliExtension.ps1

The throwing check that a named Azure CLI extension is installed. It only asserts and never installs, so a command that needs the
extension fails with a clear remediation.

## help

### synopsis

Asserts that an Azure CLI extension is installed, throwing with remediation if not.

### description

Throws a remediation-bearing error when the named extension is missing, so a command that depends on it fails fast with a clear message
instead of a cryptic argument error (az exit code 2) or — with dynamic install disabled in Invoke-AzCli — a hang on the install prompt.
Asserts only; it never installs the extension, mirroring how Assert-AzCliConnected asserts rather than logging in.

Guard an extension-dependent call by asserting immediately before it:

```text
Assert-AzCliExtension 'ip-group'
Invoke-AzCli "network ip-group list --resource-group $rg -o json" -PassThru
```

### parameter `Name`

The required extension name (e.g. 'ip-group').

### example 1

```powershell
Assert-AzCliExtension 'ip-group'
```

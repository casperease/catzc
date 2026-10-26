# pwsh/Azure.Cli/Connect-AzCli.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Logs in to Azure CLI.

### description

Skips login if already authenticated. Use -Force to re-authenticate.

### parameter `ServicePrincipal`

Login as a service principal. Requires Tenant, ClientId, and ClientSecret.

### parameter `ManagedIdentity`

Login using managed identity.

### parameter `DeviceCode`

Login using device code flow (for environments without a browser).

### parameter `Tenant`

Azure AD tenant ID. Required for service principal login.

### parameter `ClientId`

Service principal app/client ID. Required for service principal login.

### parameter `ClientSecret`

Service principal secret. Required for service principal login.

### parameter `Force`

Force re-authentication even if already logged in.

### example 1

```powershell
Connect-AzCli
```

### example 2

```powershell
Connect-AzCli -DeviceCode
```

### example 3

```powershell
Connect-AzCli -ServicePrincipal -Tenant $t -ClientId $id -ClientSecret $secret
```

### example 4

```powershell
Connect-AzCli -ManagedIdentity
```

## comment:1

Above `if (-not $Force) {`, written with `#`.

```text
Idempotent: skip if already logged in with the correct identity
-NoAssert: non-zero exit means "not logged in" — an expected state, not an error
```

## comment:2

Above `Write-Verbose "Authenticating via $($PSCmdlet.ParameterSetName)"`, written with `#`.

```text
No post-login assertion needed — Invoke-Executable throws on non-zero exit
codes via Assert-LastExitCodeWasZero. If az login fails, we never reach the
Write-Message below.
```

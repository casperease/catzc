# pwsh/Azure.Cli/Connect-AzCli.ps1

The command that logs in to the Azure CLI, interactively, by device code, as a service principal or as a managed identity. It is
idempotent: an existing login is kept unless `-Force` asks for a new one.

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

## Idempotent login

Without `-Force` the command first runs `az account show` and skips the login when the session already holds the right identity. That
probe passes `-NoAssert`, because a non-zero exit only means "not logged in", an expected state and not an error.

## No post-login check

The login needs no assertion after it: `Invoke-Executable` throws on a non-zero exit code, so a failed `az login` never reaches the
"Authenticated" message.

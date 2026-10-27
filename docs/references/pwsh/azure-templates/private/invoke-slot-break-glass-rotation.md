# pwsh/Azure.Templates/private/Invoke-SlotBreakGlassRotation.ps1

The function that rotates one slot's break-glass SQL password for `Invoke-BreakGlassRotation`: the server first, then the vault.

## help

### synopsis

Rotates one slot's break-glass SQL password, on the server and in its Key Vault secret.

### description

Generates a password, sets it on the SQL server with `az sql server update` (silent, so the argument is never echoed), then writes it to the
secret with `az keyvault secret set --file`, from a temporary file deleted right after. A failure names the server, the slot and the az exit
code, never the password.

### parameter `Target`

The slot's `Slot`, `ResourceGroup`, `Server`, `Vault` and `Secret`.

### parameter `Length`

Length of the new password, 16 to 128 characters. Default: 32.

### parameter `DryRun`

Names what the rotation would change, and changes nothing.

### example 1

```powershell
Invoke-SlotBreakGlassRotation -Target $target -DryRun
```

## comment:1

Above `$password = New-BreakGlassPassword -Length $Length`, written with `#`.

```text
The password lives only in this process: it reaches az as an argument the call never echoes (-Silent) and a failure never repeats,
and reaches the vault through a file deleted at once, so no command line, log or error carries it.
```

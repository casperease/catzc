# pwsh/Azure.Templates/private/Set-KeyVaultSecretValue.ps1

The one writer of a Key Vault secret value, for the break-glass rotation and the anomaly alert's recipient seed.

## help

### synopsis

Writes a value to a Key Vault secret and returns the az exit code.

### description

Writes the value to a temporary UTF-8 file, runs `az keyvault secret set --file` on it silently, and deletes the file right after, so the
value is never an argument, a log line or a file left behind. The caller branches on `-DryRun` before it calls, and turns a non-zero exit
code into its own error.

### parameter `Vault`

The vault's name.

### parameter `Name`

The secret's name.

### parameter `Value`

The value to write.

### example 1

```powershell
$exitCode = Set-KeyVaultSecretValue -Vault $vault -Name $secretName -Value $password
```

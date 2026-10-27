# pwsh/Azure.Templates/Invoke-BreakGlassRotation.ps1

The command that rotates the break-glass SQL passwords of an environment's `expedition` slots: for each, a new password on the SQL server,
then the same password in the Key Vault secret the slot's parameter file references. The monthly CRON pipeline
`cron-break-glass-rotation.yaml` runs it for `prod`.

## help

### synopsis

Rotates the break-glass SQL passwords of an environment's expedition slots, on each server and in its Key Vault secret.

### description

Enumerates the environment's expedition slots, narrowed to one customer when one is given, and rotates each slot whose
`administratorLoginPassword` is a Key Vault reference, one after another, reporting each. A slot's own configuration says where its password
lives: the server and its resource group are its derived names, and the vault and the secret are its Key Vault reference. Each password is
generated in the process, set on the server first and written to the secret second, and no command line, message or error carries it. No
slot with a reference in the selection is an error.

### parameter `Environment`

Environment shortname whose expedition slots are rotated.

### parameter `Customer`

Narrows the rotation to this customer's slots; empty rotates every slot of the environment.

### parameter `Length`

Length of the new password, 16 to 128 characters. Default: 32.

### parameter `DryRun`

Names the server, the vault and the secret the rotation would change, and changes nothing.

### example 1

```powershell
Invoke-BreakGlassRotation prod -DryRun
```

### example 2

```powershell
Invoke-BreakGlassRotation prod
```

### example 3

```powershell
Invoke-BreakGlassRotation dev -Customer apex
```

## Server first, then the vault

The server gets the new password before the vault does. A failed server update leaves both on the old password. A failed vault write leaves
a server password nobody holds, and running the rotation again sets a fresh one on both, so the remedy is always the same command.

## The password never leaves the process

`az sql server update` takes the password as an argument, so the call runs `-Silent` (no command echo) and `-NoAssert` (a failure reports
its exit code, never the command). The vault write reads the password from a file deleted right after, so the password is never an argument
there either. The password is drawn from the system's cryptographic generator, with every character class SQL requires and no character a
command line would change.

## comment:1

Above `$slots = @((Get-BicepTemplate expedition).slots | Where-Object {`, written with `#`.

```text
Every expedition slot of the environment, narrowed to one customer when one is given; a slot with a break-glass password is one
whose administratorLoginPassword is a Key Vault reference.
```

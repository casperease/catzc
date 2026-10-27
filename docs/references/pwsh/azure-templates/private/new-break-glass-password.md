# pwsh/Azure.Templates/private/New-BreakGlassPassword.ps1

The function that generates a break-glass SQL password for `Invoke-BreakGlassRotation`.

## help

### synopsis

Generates a random password that meets the SQL complexity rules.

### description

Draws every character from the system's cryptographic generator: one from each class SQL requires (upper case, lower case, digit, symbol),
the rest from all of them, then shuffles. The symbols exclude quotes, backslashes, spaces and dollar signs, so the password passes through a
command line unchanged.

### parameter `Length`

Length of the password, 16 to 128 characters. Default: 32.

### example 1

```powershell
New-BreakGlassPassword -Length 32
```

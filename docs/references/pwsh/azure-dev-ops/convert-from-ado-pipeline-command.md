# pwsh/Azure.DevOps/ConvertFrom-AdoPipelineCommand.ps1

The function that sanitizes a command string received from an ADO pipeline step before anything runs it.

## help

### synopsis

Sanitizes a command string received from an ADO pipeline step.

### description

When ADO passes a command string through YAML template parameters, task arguments, and into PowerShell, the string accumulates escaping
artifacts: carriage returns from Windows line endings, mixed newlines depending on whether the source YAML used folding (>) or literal (|)
block scalars, and trailing whitespace from YAML indentation. By the time the string reaches PowerShell, YAML has already been parsed — this
function only deals with the resulting plain string, not YAML syntax.

This function normalizes the string for safe use with `[ScriptBlock]::Create(`).

### parameter `Command`

The raw command string as received from ADO pipeline arguments.

### example 1

```powershell
ConvertFrom-AdoPipelineCommand "  Get-Process `r`n  Get-Service  "
# Returns: "Get-Process\nGet-Service"
```

### example 2

```powershell
# In Invoke-AdoScript.ps1:
$sanitized = ConvertFrom-AdoPipelineCommand $Command
$block = [ScriptBlock]::Create($sanitized)
Invoke-Command -ScriptBlock $block -NoNewScope
```

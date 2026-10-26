# pwsh/Base.QualityGates/Test-ManagedGuid.ps1

The query form of the managed-GUID check: it answers whether a GUID is registered in the registry `configs/guids.yml`.

## help

### synopsis

Answers whether a GUID is registered in the managed-GUID registry (configs/guids.yml).

### description

The boolean counterpart of Assert-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they can never disagree. Comparison is
case-insensitive by `[guid]` value.

### parameter `Guid`

The GUID to check.

### outputs

`[bool]` $true when the GUID is registered; $false otherwise.

### example 1

```powershell
Test-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
```

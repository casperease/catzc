# pwsh/Base.QualityGates/Assert-ManagedGuid.ps1

The throwing form of the managed-GUID check: it asserts that a GUID is registered in the registry `configs/guids.yml` and throws when it is
not.

## help

### synopsis

Asserts a GUID is registered in the managed-GUID registry (configs/guids.yml); throws when it is not.

### description

The throwing counterpart of Test-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they can never disagree. Comparison is
case-insensitive by `[guid]` value. Succeeds silently — the absence of an error is the output.

### parameter `Guid`

The GUID to assert.

### example 1

```powershell
Assert-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
```

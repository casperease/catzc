# pwsh/Catzc.Base.QualityGates/Assert-ManagedGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

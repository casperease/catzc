# automation/Catzc.Base.QualityGates/Test-ManagedGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Answers whether a GUID is registered in the managed-GUID registry (configs/guids.yml).

### description

The boolean counterpart of Assert-ManagedGuid; both share one lookup (Resolve-ManagedGuid), so they
can never disagree. Comparison is case-insensitive by `[guid]` value.

### parameter Guid

The GUID to check.

### outputs

`[bool]` $true when the GUID is registered; $false otherwise.

### example 1

```powershell
Test-ManagedGuid '499b84ac-1321-427f-aa17-267ca6975798'
```

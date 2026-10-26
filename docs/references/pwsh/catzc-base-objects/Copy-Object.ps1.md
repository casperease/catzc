# pwsh/Base.Objects/Copy-Object.ps1

The deep clone of a PowerShell object, copying dictionaries, custom objects, arrays and lists without any serialization.

## help

### synopsis

Deep clones a PowerShell object.

### description

Recursively copies hashtables, ordered dictionaries, PSCustomObjects, arrays, and lists. Value types and strings are returned as-is
(immutable or copied by value). Unknown reference types are returned by reference.

PSCustomObject cloning only copies NoteProperties. Use -AcceptWarnings to suppress the warning about this limitation.

Does not use BinaryFormatter or any serialization-based approach.

### parameter `InputObject`

The object to deep clone.

### parameter `AcceptWarnings`

Suppresses warnings about PSCustomObject cloning limitations.

### example 1

```powershell
$clone = Copy-Object $original
```

### example 2

```powershell
$clone = Copy-Object $original -AcceptWarnings
```

# pwsh/Base.Objects/ConvertTo-BclValue.ps1

The unwrapper that gives a .NET type plain BCL values: it strips PowerShell's PSObject wrapper from a value and everything nested in it.

## help

### synopsis

Unwraps a value and everything nested in it from PowerShell's PSObject wrapper, so a .NET type receives plain BCL values.

### description

Walks dictionaries and lists recursively and returns each value's base object. Null, strings and value types come back as they are. A
hashtable is cloned, so it keeps its key comparer; any other dictionary becomes an ordered dictionary in its key order; an array stays an
array and any other list becomes a list. Any other object is returned as its base object, uncopied.

The caller's collections are never changed: every dictionary and list in the result is a new copy.

### parameter `InputObject`

The value to unwrap; null is allowed.

### example 1

```powershell
$plain = ConvertTo-BclValue @{ widget = @('gadget', 'sprocket' | ForEach-Object { $_ }) }
```

## Hashtables

A hashtable is cloned, so the copy keeps the table's key comparer. The values are then replaced on the copy, never on the caller's table.

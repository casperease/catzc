# pwsh/Catzc.Base.Objects/ConvertTo-BclValue.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$copy = $Object.Clone()`, written with `#`.

```text
Clone keeps the table's key comparer; the values are then replaced on the copy, never on the caller's
table.
```

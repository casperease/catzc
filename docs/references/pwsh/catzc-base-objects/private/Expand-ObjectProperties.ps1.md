# pwsh/Base.Objects/private/Expand-ObjectProperties.ps1

The private recursion behind `ConvertTo-FlatSettingSet`: it walks a nested value and adds a dot-notation key for each leaf.

## help

### synopsis

Recursively flattens a nested object into dot-notation key/value pairs.

### description

Walks PSCustomObject, IDictionary, and array structures, building dot-separated paths for each leaf value and adding them to the supplied
OrderedDictionary. Arrays use `[index]` notation. Used internally by ConvertTo-FlatSettingSet.

### parameter `Value`

The object, or the nested value, to flatten.

### parameter `Target`

The ordered dictionary that receives the dot-notation key/value pairs.

### parameter `Prefix`

The key path so far, extended with each property name or `[index]` on the way down.

### parameter `MaxDepth`

The depth at which flattening stops. Default 10.

### parameter `Depth`

The depth reached so far; callers leave it at 0 and the recursion raises it.

## Shape order

A dictionary and an array are checked before a `PSCustomObject`. A top-level value arrives wrapped in a `PSObject`, because
`ConvertTo-FlatSettingSet` binds `[PSObject[]]`, and a wrapped dictionary matches `-is [PSCustomObject]`. Routing it there would reflect the
dictionary's own CLR members (`Count`, `Keys`, `SyncRoot`) instead of its entries. Matching the more specific shapes first keeps a dictionary
a dictionary and an array an array, wrapped or not.

## Complex CLR objects

A complex CLR object, such as a typed and validated config model, is flattened by reflecting over its public members, so a typed config
subtree flattens the same way a dictionary or a `PSCustomObject` does. Strings and value types (numbers, booleans, `DateTime`, `Guid`,
enums) fall through to leaves.

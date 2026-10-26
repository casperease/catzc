# pwsh/Base.Objects/ConvertTo-YamlSafe.ps1

The converter that reduces an object to ordered dictionaries, arrays and scalars, which `ConvertTo-Yaml` serializes cleanly.

## help

### synopsis

Recursively converts an object into a YAML-safe structure of ordered dictionaries, arrays, and scalar values.

### description

Used by Write-Object to produce clean YAML output for nested objects. Walks PSCustomObject, IDictionary, and IEnumerable types, converting
each level into ordered hashtables or arrays that ConvertTo-Yaml can serialize without falling back to ToString().

### parameter `Value`

The object to convert; null stays null.

### parameter `MaxDepth`

The depth at which a value stops being walked and is rendered as its string form. Default 10.

### parameter `Depth`

The depth reached so far; callers leave it at 0 and the recursion raises it.

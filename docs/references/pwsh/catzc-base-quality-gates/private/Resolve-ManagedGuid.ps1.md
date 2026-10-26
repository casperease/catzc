# pwsh/Base.QualityGates/private/Resolve-ManagedGuid.ps1

Resolves a GUID to its managed-registry entry, or `$null` when it is unregistered. Test-ManagedGuid and Assert-ManagedGuid both route
through this lookup, so the boolean and the throw cannot disagree.

## help

### synopsis

Resolves a GUID to its managed-registry entry, or $null when it is unregistered.

### description

The one comparison source behind Test-ManagedGuid and Assert-ManagedGuid — both route through this lookup, so the bool and the throw can
never drift. Comparison is by `[guid]` value, so any input casing matches the canonical lowercase form the registry stores.

### parameter `Guid`

The GUID to look up in the managed registry; its casing does not matter.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` @{ name; guid; description } for a registered GUID; $null otherwise.

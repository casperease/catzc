# pwsh/Catzc.Base.QualityGates/private/Resolve-ManagedGuid.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

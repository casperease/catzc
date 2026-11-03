# pwsh/Base.QualityGates/private/Get-TestDiscoveryCache.ps1

Reads the cross-session discovery file that Get-TestDiscovery keeps its stored records in.

## help

### synopsis

Returns the stored discovery records keyed by file path and content digest.

### description

An absent file, an unreadable file and a file that does not hold an object each give an empty cache, so Get-TestDiscovery discovers the
files again; an unreadable file is reported through Write-Message. An entry that lacks its blocks or tests is dropped. The file is
out/cache/test-discovery.json, and Save-TestDiscoveryCache writes it.

### parameter `Path`

The discovery cache file.

### outputs

A hashtable of the valid entries, empty when there are none.

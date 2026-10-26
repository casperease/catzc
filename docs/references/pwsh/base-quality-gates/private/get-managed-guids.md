# pwsh/Base.QualityGates/private/Get-ManagedGuids.ps1

The accessor for the managed-GUID registry: the named GUIDs the repository is allowed to carry. It reads the `guids` config once per session
and hands back a read-only map, so every GUID check shares one source.

## help

### synopsis

Returns the managed-GUID registry entries — the named GUIDs the repository is allowed to carry.

### description

Thin accessor over Get-Config -Config guids (mapped and validated by the GuidsConfig type on load, session-cached). The returned map is
read-only. Each entry is name -> ManagedGuidEntry { guid, description [, sentence] }; `sentence` is set when the GUID was minted from a
sentence with ConvertTo-Guid.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` entry-name -> entry (empty when the registry has no entries).

### example 1

```powershell
Get-ManagedGuids
```

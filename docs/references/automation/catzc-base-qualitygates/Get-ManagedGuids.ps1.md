# automation/Catzc.Base.QualityGates/Get-ManagedGuids.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

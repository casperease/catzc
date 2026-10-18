# automation/Catzc.Base.Objects/ConvertTo-FlatSettingSet.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Flattens a nested object into an ordered dictionary of dot-notation key/value pairs.

### description

Recursively walks a PSCustomObject (e.g. parsed JSON/YAML configuration)
and returns an OrderedDictionary where each key is the full dot-separated
path to a leaf property and each value is the leaf value.

Non-leaf nodes (objects, dictionaries, arrays) are expanded, not included.
Null values are stored as empty strings.

Supports pipeline input for batch processing.

### parameter InputObject

One or more objects to flatten.

### parameter MaxDepth

Maximum recursion depth. Defaults to 10.

### example 1

```powershell
$config = Get-Content config.json | ConvertFrom-Json
$flat = $config | ConvertTo-FlatSettingSet
$flat.Keys | ForEach-Object { "$_ = $($flat[$_])" }
# app.name = myapp
# app.settings.timeout = 30
```

### example 2

```powershell
$flat = ConvertTo-FlatSettingSet $config
foreach ($key in $flat.Keys) {
    Assert-False ($flat[$key] -eq 'UNDEFINED') "Key '$key' is not defined"
}
```

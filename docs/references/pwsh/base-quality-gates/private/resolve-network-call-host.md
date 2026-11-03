# pwsh/Base.QualityGates/private/Resolve-NetworkCallHost.ps1

The mapping from a config name to the host of its package source.

## help

### synopsis

Returns the lowercase host of the package source url of a named config.

### description

Reads the package source url of the named config, drops the scheme, keeps the part before the first slash and drops a trailing port. The
result is lowercased, so it compares against a host regardless of case.

### parameter `ConfigName`

The name of the config whose package source url is read.

### outputs

`[string]` The lowercase host.

### example 1

```powershell
Resolve-NetworkCallHost -ConfigName 'go'
```

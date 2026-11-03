# pwsh/Base.Languages/Get-GoEnvironment.ps1

The environment variables a go command runs with, derived from the go package source.

## help

### synopsis

Returns the environment variables that point go at the configured package source.

### description

Reads the package source of the go config and sets `GOPROXY` to its url, or to `off` with `-Offline`. When the url is not the default go
proxy, it also sets `GOPRIVATE` to the url's host and turns `GOSUMDB` off. The credential variable of the package source is not wired here,
since go reads a proxy credential from `~/.netrc`.

### parameter `Offline`

Sets `GOPROXY` to `off`, so go resolves from its cache and vendor folder only.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The variable names and their values.

### example 1

```powershell
Get-GoEnvironment -Offline
```

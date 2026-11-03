# pwsh/Base.Languages/New-Npmrc.ps1

The generator of the .npmrc text that points npm at the configured package source.

## help

### synopsis

Returns the text of an .npmrc for the javascript package source.

### description

Reads the package source of the javascript config and writes a `registry` line with the url ending in one slash. When the source names a
credential variable, adds an `_authToken` line that refers to that variable, which npm expands at run time, so the token itself is never
written. The lines are joined with line feeds and end with one.

### outputs

`[string]` The .npmrc text.

### example 1

```powershell
New-Npmrc
```

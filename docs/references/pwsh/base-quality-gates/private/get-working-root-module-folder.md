# pwsh/Base.QualityGates/private/Get-WorkingRootModuleFolder.ps1

The one list of the module folders the working root holds, in either run mode.

## help

### synopsis

Returns the module folders of the working root, dot folders excluded.

### description

With -ModulesRoot, lists the folders directly under that root. In build mode it reads the working root's own modules tracks by layout, never
the code root the bundle installed; in source mode it lists the folders of the code root. A folder whose name starts with a dot is no module
and is left out.

### parameter `ModulesRoot`

The root whose folders to list, instead of the run mode's own.

### outputs

`[string[]]` The module folder paths.

### example 1

```powershell
Get-WorkingRootModuleFolder
```

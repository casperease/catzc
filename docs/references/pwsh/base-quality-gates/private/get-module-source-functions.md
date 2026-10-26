# pwsh/Base.QualityGates/private/Get-ModuleSourceFunctions.ps1

Lists a source module's public and private function names from its files. A module is its folder: the root `.ps1` files are public and those
in `private/` are private, one function per file.

## help

### synopsis

Lists a source module's public and private function names, from its files.

### description

A module is its folder: `<Module>/*.ps1` are its public functions and `<Module>/private/*.ps1` its private ones, one function per file named
for the file. This reads the names from the file names, so a build can be compared with the source folder it was built from
(Test-BuildArtifact's parity facet).

### parameter `ModulesRoot`

The pwsh track folder (pwsh/) of the source tree.

### parameter `Name`

The module folder name.

### outputs

`[pscustomobject]` { Public = `[string[]]`; Private = `[string[]]` }, each ordinally sorted.

### example 1

```powershell
Get-ModuleSourceFunctions -ModulesRoot (Get-CatzcModulesRoot) -Name Catzc.Base.Config
```

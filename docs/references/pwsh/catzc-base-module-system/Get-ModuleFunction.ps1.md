# pwsh/Catzc.Base.ModuleSystem/Get-ModuleFunction.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists all exported functions of the catzc modules.

### description

Takes the modules of the code track from the resolver (Get-CatzcModule), finds the matching loaded modules, and returns their exported
functions.

With -NotUsedInternally, filters to functions that are never called by another catzc function (no incoming edges in the call graph).

The listing describes the loaded modules, so it works in both run modes ([DDR-RUNMODE](../../../drs/design/run-modes.md)).
-NotUsedInternally reads the per-function source files, so it stops with a named error in build mode (Assert-SourceTree).

### parameter `NotUsedInternally`

Only return functions that have no incoming calls from other catzc functions.

### parameter `ModulesRoot`

Path to the modules folder. Defaults to the loaded code root (Get-CatzcModulesRoot).

### example 1

```powershell
Get-ModuleFunction
```

### example 2

```powershell
Get-ModuleFunction -NotUsedInternally
```

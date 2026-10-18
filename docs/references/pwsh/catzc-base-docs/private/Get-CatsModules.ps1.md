# pwsh/Catzc.Base.Docs/private/Get-CatsModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists the loaded catzc modules and the public functions each exports, for Show-Cats.

### description

Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot) and is not dot-prefixed (a
dot-prefix means infrastructure, [ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../../../adr/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), with the
functions it exports. Because it reads what is loaded rather than the per-function files, the answer is the same in source mode and in build
mode, where each module's functions are merged into one file
([ADR-DSGN-RUNMODE-SAMEMODULEINBOTH](../../../../adr/design/run-modes.md#rule-adr-dsgn-runmode-samemoduleinboth)). Private functions are never exported, so they never
appear.

Private helper for Show-Cats; not exported.

### parameter `ModulesRoot`

The code root whose loaded modules to list. Defaults to Get-CatzcModulesRoot. A test points this at a fixture root from which it loaded
fixture modules.

### outputs

`[object[]]` One { Module; Functions } per module, sorted by module name, each Functions list sorted.

## comment:1

Above `$loaded = foreach ($module in (Get-Module)) {`, written with `#`.

```text
Called from inside a module, Get-Module also lists that module's own nested .ps1 function files (one per
function in source mode, the merged <Module>.ps1 in build mode). A module is its folder (folder = module),
so keep only the entry named for its folder whose root file is not a nested .ps1.
```

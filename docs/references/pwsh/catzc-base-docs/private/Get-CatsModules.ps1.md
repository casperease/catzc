# pwsh/Base.Docs/private/Get-CatsModules.ps1

The private module lister of `Show-Cats`: it reads the loaded session and returns each catzc module with its exported functions.

## What counts as a module

A cats module is a folder of the modules root that a module of the same name is loaded from (folder = module). The bounded walker lists the
folders one level deep, and a dot-prefixed one is skipped as infrastructure. A module folder drops the namespace the module's name carries,
so a loaded module is matched to its folder by the folder it loaded from, never by name. `Get-Module` can also report a nested `.ps1`
function file (one per function in source mode, the merged `<Module>.ps1` in build mode), so only the entry whose path sits directly in the
folder and is not a `.ps1` file counts.

## help

### synopsis

Lists the loaded catzc modules and the public functions each exports, for Show-Cats.

### description

Reads the loaded session: every module whose folder sits directly under the code root (Get-CatzcModulesRoot) and is not dot-prefixed (a
dot-prefix means infrastructure,
[ADR-REPO-FOLDERS-DOTMEANSTOOLING](../../../../drs/repository/conventional-folders.md#rule-adr-repo-folders-dotmeanstooling)), with the
functions it exports. Because it reads what is loaded rather than the per-function files, the answer is the same in source mode and in build
mode, where each module's functions are merged into one file
([DDR-RUNMODE-SAMEMODULEINBOTH](../../../../drs/design/run-modes.md#rule-ddr-runmode-samemoduleinboth)). Private functions are never
exported, so they never appear.

Private helper for Show-Cats; not exported.

### parameter `ModulesRoot`

The code root whose loaded modules to list. Defaults to Get-CatzcModulesRoot. A test points this at a fixture root from which it loaded
fixture modules.

### outputs

`[object[]]` One { Module; Functions } per module, sorted by module name, each Functions list sorted.

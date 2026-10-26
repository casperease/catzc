# pwsh/Tooling.Provisioning/private/Get-PackageTreePlan.ps1

A private helper of `Install-Zsh`: the plan of a copy from an extracted package tree into a destination tree, which marks the files the
destination already has so the copy leaves them alone and the uninstall never deletes them.

## help

### synopsis

Plans copying an extracted package tree into a destination tree without touching a file the destination already has.

### description

Compares the files and folders under -Source with -Destination and returns paths relative to both roots, with forward slashes:

```text
Directories  the folders the destination lacks, parents before children, so creating them in order works;
Files        the files the destination lacks: the ones a copy adds, and the only ones an uninstall may delete;
Kept         the files the destination already has: they belong to whoever placed them, so a copy leaves them alone.
```

Reads the filesystem only and changes nothing, so the plan can be recorded before the copy starts and an interrupted copy is still covered
by it
([ADR-AUTO-REMOVE-UNINSTALLMANAGEDONLY](../../../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-uninstallmanagedonly)).

### parameter `Source`

The extracted package tree.

### parameter `Destination`

The tree the package is copied into.

### outputs

`[pscustomobject]` { Directories; Files; Kept }

### example 1

```powershell
Get-PackageTreePlan -Source $staging -Destination $gitHome
```

## The walk

The walk of the source tree is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)). A copy plan must
see every file, so no folder name is pruned and the depth is the config's ceiling. A real package tree reaches ten levels, and a shallower
bound would silently drop files from the copy.

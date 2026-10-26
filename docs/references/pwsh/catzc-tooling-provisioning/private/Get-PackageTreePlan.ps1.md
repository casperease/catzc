# pwsh/Tooling.Provisioning/private/Get-PackageTreePlan.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

## comment:1

Above `$sourceDirectories = [System.Collections.Generic.List[string]]::new()`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM-ALWAYSBOUNDED](/docs/drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)): a copy
plan must see every file, so no folder name is pruned and the depth is the
config's ceiling. A real package tree reaches ten levels, and a shallower bound would silently drop files from the copy.
```

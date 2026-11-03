# pwsh/Base.Repository/Resolve-CodeModuleFolder.ps1

The one mapping between a module's bare folder name and the folder the code root holds for it, in both run modes.

## help

### synopsis

Returns the folder the code root holds for a bare module folder name, or the bare name of a code-root folder.

### description

A source tree names a module's folder without the namespace (`Base.Widget`), while a built root names it with the product namespace
(`Catzc.Base.Widget`), and a consumer overlay folder under `.catzc/<modules folder>/` stays bare in both
([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)). The run mode is derived, never stored
([DDR-RUNMODE-MODEISDERIVED](../../../drs/design/run-modes.md#rule-ddr-runmode-modeisderived)), and the namespace of catzc's own modules is
the reserved product token `Catzc`, so a built folder is `Catzc.<bare>` by construction
([PDR-CATS-CATZCISSOURCENAME](../../../drs/principles/cats-and-catzc.md#rule-pdr-cats-catzcissourcename)).

With `-Name`, the command returns the full path of the code-root folder for that bare name in the current run mode, and nothing when the
code root holds none or the name is a dot folder (`.internal`, `.vendor`), which is no module. With `-BareName`, it returns the bare name of
a code-root folder: the namespace is stripped in a built root, and a source folder or a dot folder comes back as it is.

### parameter name

The bare module folder name to look up in the code root, such as `Base.Widget`.

### parameter bareName

A folder name as the code root holds it, to turn into the bare name an overlay folder carries.

### example 1

```powershell
Resolve-CodeModuleFolder -Name 'Base.Widget'
```

### example 2

```powershell
Resolve-CodeModuleFolder -BareName 'Catzc.Base.Widget'
```

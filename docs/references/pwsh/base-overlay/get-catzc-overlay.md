# pwsh/Base.Overlay/Get-CatzcOverlay.ps1

The inventory of the consumer overlay: it walks the overlay folder and classifies every file by where it sits, loading and checking nothing.

## help

### synopsis

Lists everything in the consumer overlay, each entry classified by where it sits.

### description

Under .catzc/automation/ a file's location is its meaning: it sits at the path of what it changes in the bundle's code root
([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)). A folder named for a bundled module changes that module, and within it:

```text
<Function>.ps1          FunctionOverride (public)    replaces the module's public function <Function>
private/<Function>.ps1  FunctionOverride (private)   replaces the module's private function <Function>
configs/<config>.yml    ConfigFragment               merges onto the bundled config (Get-Config)
assets/<path>           AssetOverride                replaces the bundled asset (Get-CatzcModuleRoot)
tests/<path>            LocalTest                    a local test of the module as overridden
anything else           Unknown                      not an override point (Assert-CatzcOverlay rejects it)
```

A folder that names no bundled module is a LocalModule. Nothing is loaded or checked here; the inventory is what Assert-CatzcOverlay checks
and Import-CatzcOverlay applies, and what a reader asks to see what a session changed. Returns nothing when there is no overlay (source
mode, or no .catzc/automation/).

### outputs

`[pscustomobject]` Kind, Module, Target, Visibility, File, RelativePath — in ordinal path order.

### example 1

```powershell
Get-CatzcOverlay | Format-Table Kind, Module, Target
```

## The walk prunes nothing

Every file of a consumer module is classified, so the walk is a named whole-tree walk
([ADR-PWSH-ENUM-ALWAYSBOUNDED](../../../drs/automation/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum-alwaysbounded)) that excludes nothing:
a skipped file would be an override nobody sees.

## Where the paths and names come from

The overlay root is `.catzc/<track folder>`
([PDR-CATS-FOLDERSUSECATZC](../../../drs/principles/cats-and-catzc.md#rule-pdr-cats-foldersusecatzc)) and names its own folder, so the
records spell no track folder of their own.

An overlay folder mirrors a bundled module's folder, which never spells the namespace; the record carries the folder and the full name the
resolver gives it ([DDR-TRACK-MODULENAMESPACE](../../../drs/design/tracks.md#rule-ddr-track-modulenamespace)). A local module's name is its
folder's.

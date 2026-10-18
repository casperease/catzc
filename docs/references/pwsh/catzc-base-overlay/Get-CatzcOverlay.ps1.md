# pwsh/Catzc.Base.Overlay/Get-CatzcOverlay.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lists everything in the consumer overlay, each entry classified by where it sits.

### description

Under .catzc/automation/ a file's location is its meaning: it sits at the path of what it changes in the bundle's code root
([ADR-AUTO-OVERLAY](../../../adr/automation/consumer-overlay.md)). A folder named for a bundled module changes that module, and within it:

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

## comment:1

Above `$files = [string[]] @(Get-ChildPath $folder -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): every
file of a consumer module is classified, so nothing is pruned.
```

## comment:2

Above `$prefix = ".catzc/$([System.IO.Path]::GetFileName($overlayRoot.TrimEnd('\',...`, written with `#`.

```text
The overlay root is .catzc/<track folder> ([ADR-PRIN-CATS#5](/docs/adr/principles/cats-and-catzc.md#rule-adr-prin-cats5))
and names its own folder, so the records spell no track folder of their own.
```

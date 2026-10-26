# pwsh/Base.Repository/Get-CatzcOverlayRoot.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the consumer's overlay root — `<RepositoryRoot>/.catzc/automation` — or nothing when there is none.

### description

A consumer of a built bundle works in its own working root and changes what the bundle does only through its overlay, the .catzc/ folder
there ([ADR-AUTO-OVERLAY](../../../drs/automation/consumer-overlay.md)). Under .catzc/automation/ every file sits at the path of what it
changes in the bundle's code root, so this root is where a config fragment, a function override, a local module, or a local test is looked
for.

The overlay applies in build mode only. In source mode the catzc tree is automation/ itself and is changed there directly, so the function
returns nothing even when a .catzc/ folder exists; it also returns nothing when the working root has no .catzc/automation/. It is derived,
never stored, like the run mode: it cannot disagree with what loaded.

### outputs

`[string]` The full path of the overlay root, or nothing.

### example 1

```powershell
Get-CatzcOverlayRoot
```

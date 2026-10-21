# pwsh/Catzc.Base.Vendor/Remove-VendorModules.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Removes vendored modules from pwsh/.vendor, validating first that each is restorable from the source.

### description

Doubles as the "committed binaries are available on the network" check. For every targeted vendored module it queries the configured source
(configs/vendor.yml) for its committed version:

- Without -Force it changes nothing: it reports each target, whether the source can restore it, and the exact recreate command — a dry run.
- With -Force it deletes each target's `pwsh/.vendor/<Name>` folder, but only after confirming every target is restorable. If any is NOT
  available on the source, it refuses the whole run (deleting would be irreversible) — so a removal is always reversible, whether by
  Install-VendorModule or `git restore`.

A PR that strips vendored binaries (to slim the repo, leaning on the source) runs this to prove the set is reproducible before deleting.

Deletes from the source tree's .vendor, so it stops with a named error in build mode (Assert-SourceTree,
[DDR-RUNMODE](../../../drs/design/run-modes.md)) — an installed package's vendored modules are never removed by it.

### parameter `Name`

Vendored module names to target. Defaults to every vendored module.

### parameter `Force`

Actually delete. Without it the command is a dry run (report + recreate recipe).

### example 1

```powershell
Remove-VendorModules
```

### example 2

```powershell
Remove-VendorModules -Name Pester -Force
```

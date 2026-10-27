# pwsh/Base.QualityGates/Test-BicepLint.ps1

The quality gate for the Bicep linter: it runs `bicep lint` on every tracked `.bicep` file under its paths and fails on any diagnostic, a
warning included, so a linter warning fails the build. The rule levels are read from `infrastructure/bicepconfig.json`.

## help

### synopsis

Lints every tracked Bicep file with the pinned Bicep CLI and fails on any linter diagnostic.

### description

Resolves the Bicep CLI pinned in tools.yml and lints each tracked `.bicep` file under `-Path`, one call each. The linter exits 0 on a
warning, so every `<file>(<line>,<column>) : <level> <rule>: <message>` line it prints is a finding. A non-zero exit with no diagnostic
throws. A quality gate: it ends through Write-QualityGateReport, which writes out/bicep-lint/, prints every issue, and throws once listing
them all. It needs the source tree: it throws in build mode.

### parameter `Path`

The folders whose tracked `.bicep` files are linted. Default: `infrastructure`.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/bicep-lint`.

### parameter `PassThru`

Return a result object instead of throwing.

### outputs

Throws on any finding; with -PassThru, returns the `[Catzc.Base.Reports.QualityGateResult]`.

### example 1

```powershell
Test-BicepLint
```

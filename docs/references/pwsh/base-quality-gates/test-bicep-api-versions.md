# pwsh/Base.QualityGates/Test-BicepApiVersions.ps1

The quality gate for the API versions of Bicep resource types: it reads every `type@version` reference in the configured Bicep folders and
fails on any version the configuration judges too old or not allowed.

## help

### synopsis

Fails on a Bicep resource reference whose API version is outdated or preview and not pinned.

### description

Collects the `.bicep` files in the folders of bicep-api-versions.yml (modules at a folder's root, templates one folder down) and matches
every `'<type>@<yyyy-mm-dd[-preview]>'` reference. The configuration gives a verdict per type and version against today's date; a finding
reads `file:line type@version: reason` and names the fix: move to a current stable version, or pin it in `allowed`. A quality gate: it ends
through Write-QualityGateReport, which writes out/bicep-api-versions/, prints every issue, and throws once listing them all.

### parameter `Config`

The bicep-api-versions configuration. Defaults to the shipped one.

### parameter `Today`

The date the version age is measured at. Defaults to today.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/bicep-api-versions`.

### parameter `PassThru`

Return a result object instead of throwing.

### outputs

Throws on any finding; with -PassThru, returns the `[Catzc.Base.Reports.QualityGateResult]`.

### example 1

```powershell
Test-BicepApiVersions
```

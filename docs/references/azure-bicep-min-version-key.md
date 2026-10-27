# The `bicep_min_version` key of `azure.yml`: what it said, and the pin that replaces it

## What the key said

`azure.yml` named the oldest Bicep CLI a build could run on, as MAJOR.MINOR.PATCH:

```yaml
bicep_min_version: "0.43.8"
```

`Get-AzureBicepMinVersion` read it as a `[version]`, and `Assert-AzCliBicep` compared the CLI that `az bicep version` reported against it
before every `az bicep build`, so a missing or too-old Bicep failed fast with `az bicep install` or `az bicep upgrade` instead of a build
that exited 0 and wrote no `main.json`. `Test-AzCliBicep`, `Install-AzCliBicep` and the private `Get-AzCliBicepState` served the same
check. `AzureConfig` carried the key, and the `pwsh.azure` types contract exposed it.

## Why it goes

`Build-Bicep` now runs the bicep binary directly instead of through `az bicep`, since each az call paid about 2 s of Python start, once per
slot and once for the build (all three shipped templates: 89 s through az, 31 s direct, measured 2026-10-26). The bicep binary is a
toolchain tool with its own pin in `tools.yml`, installed by `Install-Bicep`. Two pins on one binary would drift, and az's bundled bicep
(0.44.1) already sat below the `tools.yml` pin (0.48) when the switch was measured
([one-living-version](../drs/principles/one-living-version.md)).

## What replaces it

The `bicep` entry of `tools.yml`. `Build-Bicep` resolves the binary once per build with `Resolve-ToolExecutable -Tool bicep` and fails
before the output folder is wiped when it is missing or off the pinned version, naming `Install-Bicep`. The key, `Get-AzureBicepMinVersion`
and the four az-bicep functions are deleted; the Azure data-model and landing-zone decision records absorb this page when they are next
restated.

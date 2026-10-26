# pwsh/Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1

The tests of the [ArtifactsConfig](../../types/artifacts-config.md) type. Constructing it maps and validates the parsed YAML, so a
malformed publish-target map never loads through `Get-Config -Config artifacts`.

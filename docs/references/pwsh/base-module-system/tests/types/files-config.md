# pwsh/Base.ModuleSystem/tests/types/FilesConfig.Tests.ps1

The tests of the [FilesConfig](../../types/files-config.md) type, the module-to-packages manifest `Copy-CatzcModule` reads. Constructing
it maps and validates the parsed YAML, so a malformed manifest never loads through `Get-Config -Config files`.

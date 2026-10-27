# pwsh/Base.ModuleSystem/tests/types/ProfilesConfig.Tests.ps1

The tests of the `ProfilesConfig` type. Constructing it maps and validates the parsed YAML, so a malformed profile map never loads through
`Get-Config -Config profiles`.

# pwsh/Base.ModuleSystem/tests/Get-ModuleProfile.Tests.ps1

The tests of `Get-ModuleProfile`. The check over the shipped registry makes one assertion over the violating set, because an assertion per
profile and module would pay Pester's per-assertion cost times the whole registry.

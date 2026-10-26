# pwsh/Base.ModuleSystem/tests/Get-ModuleDependency.Tests.ps1

The tests of `Get-ModuleDependency`. The real-graph check makes one assertion over the violating set, because an assertion per edge would pay
Pester's per-assertion cost times the whole discovered graph.

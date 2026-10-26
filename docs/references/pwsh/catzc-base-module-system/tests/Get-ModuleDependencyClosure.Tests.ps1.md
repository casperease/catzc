# pwsh/Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1

The tests of the private `Get-ModuleDependencyClosure`, a breadth-first walk over the declared dependency map. They run through
`InModuleScope` with the map mocked to a small fixture graph, so the closure logic is exercised independent of the real graph.

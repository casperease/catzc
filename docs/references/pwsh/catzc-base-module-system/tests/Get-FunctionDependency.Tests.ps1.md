# pwsh/Base.ModuleSystem/tests/Get-FunctionDependency.Tests.ps1

The tests of `Get-FunctionDependency`. The real-tree check makes one assertion over the whole violating set, because one assertion per edge
costs about 0.5 ms across about a thousand cross-module edges, which alone would breach the L0 time limit.

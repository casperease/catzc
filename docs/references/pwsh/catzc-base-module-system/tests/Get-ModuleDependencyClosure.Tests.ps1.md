# pwsh/Catzc.Base.ModuleSystem/tests/Get-ModuleDependencyClosure.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Get-ModuleDependencyClosure' -Tag 'L0', 'logic' {`, written with `#`.

```text
Get-ModuleDependencyClosure is private (breadth-first over the declared dependency map). Tested via InModuleScope with
the map mocked to a small fixture graph, so the breadth-first/closure logic is exercised independent of the real graph.
```

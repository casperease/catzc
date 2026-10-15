# docs/references/automation/catzc-base-modulesystem/Test-ModuleCycles.ps1.md

`automation/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)) over the actual
cross-module function calls (Get-ModuleDependency). It sorts the graph topologically (Kahn's algorithm) and
reports every module the sort cannot place — each sits on a dependency cycle or is called from one.

This is the whole graph, every module included: Test-ModuleDependency checks the declared modules' edges against
the allow-list in configs/dependencies.yml, and an unconstrained module is outside that list, so a cycle through
one is caught only here. It analyses the per-function source files (Get-ModuleDependency).
```

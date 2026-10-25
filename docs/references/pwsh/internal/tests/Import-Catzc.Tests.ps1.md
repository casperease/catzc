# pwsh/.internal/tests/Import-Catzc.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Import-Catzc loads a full build (walking skeleton)'`, written with `#`.

```text
Import-Catzc loads a build: Test-BuildArtifact builds the selection once into a temporary destination (Build-Modules,
which verifies the bundle with Assert-CatzcBundle), loads it cold in a child pwsh (loaded assemblies and $env: are
process-global), and checks the load facet by facet — build mode, both roots, every built module once and from
the build root, the types DLL and its accelerators, every shipped config, help, privates, InModuleScope.
```

## comment:2

Above `It 'a reduced build ships the full type set and loads exactly its modules...`, written with `#`.

```text
A build of one module and its dependency closure still ships the full type set: the selected modules'
sources in their types/ folders, the rest under .compiled/types/, so the load-time hash finds the full DLL.
```

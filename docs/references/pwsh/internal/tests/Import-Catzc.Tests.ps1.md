# pwsh/.internal/tests/Import-Catzc.Tests.ps1

The tests of `Import-Catzc`, which loads a built Catzc package into a session.

## Loading a full build

`Test-BuildArtifact` builds the selection once into a temporary destination (`Build-Modules`, which verifies the bundle with
`Assert-CatzcBundle`) and loads it cold in a child pwsh, since loaded assemblies and `$env:` are process-global. The test then checks the
load facet by facet: build mode, both roots, every built module once and from the build root, the types DLL and its accelerators, every
shipped config, help, privates and `InModuleScope`.

## A reduced build

A build of one module and its dependency closure still ships the full type set: the selected modules' sources sit in their `types/` folders
and the rest under `.compiled/types/`, so the load-time hash finds the full DLL.

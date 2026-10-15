---
catzc:
  derived:
    path: docs/references/automation/internal/tests/Import-Catzc.Tests.ps1.md
    kind: test-asset
    body_sha: ed0518f258e5
---

# automation/.internal/tests/Import-Catzc.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Import-Catzc loads a full build (walking skeleton)' -Tag 'L2',...`.

```text
Import-Catzc loads a build: Test-BuildArtifact builds the selection once into a temporary destination (Build-Modules,
which verifies the bundle with Assert-CatzcBundle), loads it cold in a child pwsh (loaded assemblies and $env: are
process-global), and checks the load facet by facet — build mode, both roots, every built module once and from
the build root, the types DLL and its accelerators, every shipped config, help, privates, InModuleScope.
```

## comment:2

Above `It 'a reduced build ships the full type set and loads exactly its modules...`.

```text
A build of one module and its dependency closure still ships the full type set: the selected modules'
sources in their types/ folders, the rest under .compiled/types/, so the load-time hash finds the full DLL.
```

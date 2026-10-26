# pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1

The tests of `Get-DynamicManifestContent` and `New-DynamicManifest`, which write the manifest every module loads through.

## A merged module

A merged module, with every function in one nested script file, loads through its explicit manifest with only the listed publics exported
and the private still callable from them (shared module scope).

## A source module

A source module is a modules root holding the real shared loader under `.internal/assets` and one module folder of function files. Its
derived manifest loads every file into one module: the publics are exported, the private is callable from them but not exported, and each
function still reports its own source file and line.

## Formatter stability

The published manifest is a versioned immutable artifact, so its canonical form must equal what the repository formatter would produce;
otherwise a later touch would re-format and churn the stored bytes. Every `<Module>.psd1` in a build comes from `Get-DynamicManifestContent`
(`New-DynamicManifest`), and the L2 case runs `Test-BuildArtifact -Facet Manifest` over them.

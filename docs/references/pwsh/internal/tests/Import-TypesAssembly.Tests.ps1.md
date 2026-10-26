# pwsh/.internal/tests/Import-TypesAssembly.Tests.ps1

The tests of `Import-TypesAssembly`, which loads a prebuilt types assembly through a shadow copy.

## Fixture

The L1 fixture DLL is compiled once with `Add-Type` (Roslyn's cold start). The source DLL lives in `TestDrive` and is never loaded, which is
the property under test. The shadow folder lives outside `TestDrive`: on Windows the loaded copy stays locked for the process lifetime, so
`TestDrive`'s teardown could not delete it.

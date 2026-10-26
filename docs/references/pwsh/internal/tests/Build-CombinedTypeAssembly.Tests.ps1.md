# pwsh/.internal/tests/Build-CombinedTypeAssembly.Tests.ps1

<!-- cspell:ignore npublic -->

The tests of `Build-CombinedTypeAssembly`, which compiles the combined types assembly from the type sources.

## The compile case

The L1 case pays Roslyn's cold start with its first `Add-Type`. The assembly is written with `-OutputAssembly` and never loaded, so the DLL
is not locked and lives in `TestDrive`. A per-run namespace keeps the "not loaded" assertion true on a second run in the same session.

## The race case

Another session may save a `.cs` file mid-compile: the live file turns into code that does not compile the moment the compiler starts. The
build compiles a frozen copy, which neither sees the change nor names its DLL for bytes it did not compile, and the race case proves it.

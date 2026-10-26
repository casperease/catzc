# pwsh/.internal/tests/Test-IsRunningInPipeline.Tests.ps1

The tests of `Test-IsRunningInPipeline`, which detects a pipeline run from its environment variables.

## Where it lives

`Test-IsRunningInPipeline` lives in `Catzc.Internal.Loader`, which both run modes import first and keep loaded, so the test needs no import.
Each case sets the detection variables and restores them after.

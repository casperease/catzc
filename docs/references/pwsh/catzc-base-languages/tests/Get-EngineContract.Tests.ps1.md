# pwsh/Base.Languages/tests/Get-EngineContract.Tests.ps1

The logic tests of `Get-EngineContract`, with the engines' executables mocked. The start arguments come from the execution engine model and
load the run's entry, directly in pwsh and through `importer.sh` and `CATZC_IMPORTER` in the POSIX engines. The fixture paths are neutral
([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../../drs/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)).

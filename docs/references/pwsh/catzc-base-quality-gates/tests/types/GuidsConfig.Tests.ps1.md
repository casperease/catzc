# pwsh/Base.QualityGates/tests/types/GuidsConfig.Tests.ps1

The test of the `GuidsConfig` type. The all-zeros GUID is itself denied, because it must not appear as a tracked literal, so the test builds
it at runtime. That is the same discipline `Test-ManagedGuids` enforces on every other file.

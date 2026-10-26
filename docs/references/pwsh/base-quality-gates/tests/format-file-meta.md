# pwsh/Base.QualityGates/tests/Format-FileMeta.Tests.ps1

The tests of `Format-FileMeta` and `Test-FileMeta` over a fixture repository.

## Fixture kinds

The fixture kinds come with fixture processors: a role taken from the file's class, and a tint read from its body, never from its head, so
the tests prove the facts are derived and not read back.

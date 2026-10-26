# pwsh/Base.Drs/tests/Build-DrsIndex.Tests.ps1

The tests of `Build-DrsIndex`.

## Generated-file check

The importer's janitor tail materialises [index](../../../../drs/index.md) before the run, so the test checks it through
`Test-GeneratedFiles -Generator Build-DrsIndex` without writing.

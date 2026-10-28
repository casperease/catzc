# pwsh/Base.GeneratedFiles/tests/Get-GeneratedWriterDue.Tests.ps1

The L0 tests of `Get-GeneratedWriterDue`: they judge neutral widget and gadget writers against a `TestDrive:` tree, a mocked
`Get-GeneratedWriterOrder` that answers fixture writer rows, and a memo file.

## Fixtures

One fixture writer, `Build-Cog`, reads `cogs/*/cog.toml`: it stands for a writer that writes one file into every folder a wildcard claims,
as the root configs write each `pyproject.toml`.

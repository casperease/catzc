# pwsh/Base.TypesSystem/tests/Invoke-BuildForVsCode.Tests.ps1

The L0 tests of `Invoke-BuildForVsCode`.

## The offline guard

The offline guard is mocked: the modules root is the test drive, outside the repository, and the guard's own cases are in
`Assert-DotnetOffline.Tests.ps1`.

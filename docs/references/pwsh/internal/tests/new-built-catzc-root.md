# pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1

The tests of `New-BuiltCatzcRoot`, of `New-ConsumerRoot` (with `Export-Catzc` mocked) and of `Invoke-InBuiltCatzc` against them.

## The stand-in build root

`Invoke-InBuiltCatzc` runs against a stand-in build root. Its `Import-Catzc.ps1` is a fixture that sets the two roots the way the real entry
script does and prints importer-style console lines, the noise the result channel must survive. It is a real child pwsh but no importer, so
it stays fast.

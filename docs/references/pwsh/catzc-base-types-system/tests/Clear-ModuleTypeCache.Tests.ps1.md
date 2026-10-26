# pwsh/Base.TypesSystem/tests/Clear-ModuleTypeCache.Tests.ps1

The L0 tests of `Clear-ModuleTypeCache`, against fixture DLLs in a stand-in shadow root.

## The shared hash

The fixture DLL name and the real-repository drift check both use the one shared hash (`Get-CombinedTypeHash`, loaded by the importer), the
same function the janitor under test calls, so there is no separate mirror to keep in step. The independent oracle for that function is the
cross-language MSBuild stamp, tested in the `Import-CSharpTypes` test file's "IDE project build stamps" test.

## Building the fixture

The fixture is built with `[System.IO]` rather than `New-Item` and `Set-Content`: the cmdlets carry about 20 ms of per-call overhead on
Windows, which dominated this per-test setup. `CreateDirectory` makes parents too.

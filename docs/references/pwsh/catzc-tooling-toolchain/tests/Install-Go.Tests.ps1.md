# pwsh/Tooling.Toolchain/tests/Install-Go.Tests.ps1

The tests of `Install-Go`, hermetic logic (L1). The release feed (`Get-GoRelease`), the verified download, the version and tar runs
(`Invoke-Executable`), the persistent PATH seam and the final check (`Test-Tool`) are mocked; the managed home is a fixture folder under
`TestDrive`. The mocked download writes a real fixture `.zip`, which the command extracts in process, and the mocked tar writes the
`.tar.gz` archive's `go/` tree into the staging folder.

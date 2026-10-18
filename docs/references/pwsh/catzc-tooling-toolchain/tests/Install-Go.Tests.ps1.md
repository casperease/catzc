# pwsh/Catzc.Tooling.Toolchain/tests/Install-Go.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Describe 'Install-Go' -Tag 'L1', 'logic' {`, written with `#`.

```text
Hermetic logic (L1): the release feed (Get-GoRelease), the verified download, the version and tar runs
(Invoke-Executable), the persistent PATH seam and the final check (Test-Tool) are mocked; the managed home is a
fixture folder under $TestDrive. The mocked download writes a real fixture .zip (extracted in-process), and the
mocked tar writes the .tar.gz archive's go/ tree into the staging folder.
```

---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/tests/Install-Go.Tests.ps1.md
    kind: test-asset
    body_sha: "2d01226bc590"
---

# automation/Catzc.Tooling.Toolchain/tests/Install-Go.Tests.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `Describe 'Install-Go' -Tag 'L1', 'logic' {`.

```text
Hermetic logic (L1): the release feed (Get-GoRelease), the verified download, the version and tar runs
(Invoke-Executable), the persistent PATH seam and the final check (Test-Tool) are mocked; the managed home is a
fixture folder under $TestDrive. The mocked download writes a real fixture .zip (extracted in-process), and the
mocked tar writes the .tar.gz archive's go/ tree into the staging folder.
```

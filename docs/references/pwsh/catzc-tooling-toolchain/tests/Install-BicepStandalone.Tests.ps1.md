# pwsh/Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1

The tests of `Install-BicepStandalone`, the Linux path of `Install-Bicep`, with its seams mocked
([ADR-AUTO-TEST-NOOVERMOCKING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-noovermocking)): the GitHub releases API
(`Invoke-RestMethod`), the verified download (`Save-VerifiedDownload`, which writes the file) and `chmod` (`Invoke-Executable`).
`$env:HOME` points into `TestDrive`, so `~/.local/bin` is a scratch folder.

# pwsh/Tooling.Toolchain/tests/Get-GoRelease.Tests.ps1

The tests of `Get-GoRelease`. The go.dev release feed is mocked with a fixture shaped like the real one: `version`, `stable`, and a `files`
list whose entries carry `filename`, `os`, `arch`, `kind` and `sha256`.

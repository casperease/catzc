# pwsh/Base.VSCode/tests/New-VsCodeExtensions.Tests.ps1

The L0 tests of `New-VsCodeExtensions`.

## Fixtures

They isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry stands in for the shipped one. `Get-Config` constructs the `VscodeExtensionsConfig` type on load, so a render is also the
shape proof. The engines' extensions arrive as the root-config generator passes them.

The Go language server is expected for the Go tests under either Go root (`go/` or `.go/`), since it reads the repository-root `go.work`.

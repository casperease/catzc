# pwsh/Base.VSCode/tests/New-VsCodeSettings.Tests.ps1

The L0 tests of `New-VsCodeSettings`.

## Fixtures

They isolate through the config seam
([ADR-PWSH-PESTER-ISOLATETHROUGHSEAMS](../../../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-isolatethroughseams)): a small
fixture registry with an authored `search.exclude` carrying an explicit un-exclude (false) that injection must not override.

## Managed Go targets

The managed Go targets (`go.work` and the generated `go.mod` files) are injected like every managed target; the test code under either Go
root must stay visible, searchable, watched, and loaded by gopls. A VS Code glob is matched as a `-like` pattern (`**` and `*` both span
`/`), on the path and its leading `**/` form.

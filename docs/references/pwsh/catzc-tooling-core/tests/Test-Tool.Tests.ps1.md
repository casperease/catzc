# pwsh/Tooling.Core/tests/Test-Tool.Tests.ps1

The L0 tests of `Test-Tool`.

## Hermetic

Every collaborator is mocked in the module scope, so the assertion binds to the version-check logic, the pin against the devbox lever
against the pipeline, and never to the shipped `tools.yml` or the installed toolchain.

## Config mocks

`Get-ToolConfig` returns the typed record, so the mocks do too: every key the entry omits reads as its default, exactly as in production.

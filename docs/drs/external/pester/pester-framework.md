# External: Pester — the test framework

## Rules: EDR-PWSH-PESTER

### Rule EDR-PWSH-PESTER-PESTERFRAMEWORK

Pester is the test framework, and a test applies the [test-automation](../../automation/test-automation.md) (`ADR-AUTO-TEST`) doctrine —
logic isolated through seams, integrity bound to the real files — with the mock idioms and file conventions of
[pester-testing](../../automation/pwsh/pester-testing.md) (`ADR-PWSH-PESTER`).

- [Source](#source)

## Context

Pester is the test and mocking framework for PowerShell, and the source of the `Describe`, `Context`, `It`, `Mock` and `Should` vocabulary
the repository's tests are written in. The repository reads it as the framework that executes its test doctrine in pwsh, never as a source
of doctrine of its own.

## Source

Pester, <https://pester.dev/>. The repository pins one version in `pwsh/.vendor/`, and the Pester layer over the engine-neutral test
doctrine is the decision [pester-testing](../../automation/pwsh/pester-testing.md).

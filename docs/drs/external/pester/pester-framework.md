# EDR: Pester — the test framework

## Rules: EDR-PWSH-PESTER

### Rule EDR-PWSH-PESTER-PESTERFRAMEWORK

Pester is the test and mocking framework for PowerShell: tests are written as `Describe`, `Context` and `It` blocks, collaborators are
replaced with `Mock`, and outcomes are asserted with `Should`. Source: [Pester](https://pester.dev/). Binds to
[ADR-AUTO-TEST](../../automation/test-automation.md) and [ADR-PWSH-PESTER](../../automation/pwsh/pester-testing.md).

## Context

Pester is the source of the `Describe`, `Context`, `It`, `Mock` and `Should` vocabulary the repository's tests are written in. The
repository reads it as the framework that executes its test doctrine in pwsh, never as a source of doctrine of its own: the version it pins
in `pwsh/.vendor/` and the Pester layer over the engine-neutral test doctrine are the decision
[pester-testing](../../automation/pwsh/pester-testing.md).

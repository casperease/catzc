# pwsh/.scriptanalyzer/NoRawConsoleWrite.psm1

The custom analyzer check `Measure-NoRawConsoleWrite`: writing to the console past the information stream is forbidden.

## Why

A raw write bypasses the stream, so it escapes output control, Pester silencing and the caller header.

## Reading versus writing

`[Console]::Out` and `[Console]::Error` are raw writers only when written through. Reading them, to save and restore around a `SetOut`
capture, writes nothing and passes.

## Predicates

The predicates are locals, not inlined in `FindAll`'s parens, which dodges a cross-version indent skew
([ADR-PWSH-FORMAT-MULTILINEPREDICATEBOUND](../../../drs/automation/pwsh/powershell-formatting.md#rule-adr-pwsh-format-multilinepredicatebound)).

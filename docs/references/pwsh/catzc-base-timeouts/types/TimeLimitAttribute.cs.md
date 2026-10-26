# pwsh/Base.Timeouts/types/TimeLimitAttribute.cs

The attribute that declares a function's own time limit beside its code, on the param block.

## Use

```powershell
function Test-Widget {
    [CmdletBinding()]
    [Catzc.Base.Timeouts.TimeLimit(360, Pipeline = 1800)]
    param([int] $TimeoutSeconds = (Get-TimeoutSeconds -Command 'Test-Widget'))
```

`Get-TimeoutSeconds -Command` reads it when no config entry overrides it, so a long-running function carries its limit with its code and the
config only states what was tuned
([ADR-PWSH-ASSERT-DECLAREDTIMELIMIT](../../../../drs/automation/pwsh/assert-idioms.md#rule-adr-pwsh-assert-declaredtimelimit)).

## Validation

The values are checked when the attribute is created: whole seconds above zero, the pipeline limit at least the devbox one.

## Budget

`Budget` is the work's immutable budget GUID (managed in `guids.yml`); while `timeout-exemptions.yml` exempts it, the exemption's ceiling
wins. It is empty when the function has no budget.

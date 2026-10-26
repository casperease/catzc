# pwsh/Base.Timeouts/configs/timeout-exemptions.yml

The registry of time-safeguard exemptions: work that may run past its normal limit while it is being tuned.

## How it is read

`Get-Config -Config timeout-exemptions` loads it, the `TimeoutExemptionsConfig` type validates it, and `Get-TimeoutExemption`,
`Test-IsTimeoutExempt` and `Assert-IsNotTimeoutExempt` read it.

## What an exemption names

A piece of work is identified by an immutable budget GUID: minted with `ConvertTo-Guid` so it spells its name, registered in
`pwsh/Base.QualityGates/configs/guids.yml`, and passed by the call site as `-Budget` (`Invoke-WithTimeout`, `Assert-CompletesWithin`,
`Test-CompletesWithin`, `Get-TimeoutSeconds`). Renaming the call site never changes it.

An exemption never removes the limit: an exempt budget runs up to its scope's ceiling instead.

## Keys

```text
ceiling:                                   # optional; the sensible defaults are declared on the type
  <devbox|pipeline>: { pwsh: <s>, bash: <s>, zsh: <s> }
exempt:
  - single: <guid>                         # exactly one of single | range
    range: { from: <guid>, to: <guid> }    # every GUID from..to inclusive, ordered as written
    scope: { environment: <devbox|pipeline>, shell: <pwsh|bash|zsh> }   # optional; an omitted axis covers every value
    reason: <why it is exempt while it is tuned>
```

## Integrity

Every GUID here must be a registered, live budget (the exemption integrity test), and no two entries may cover the same GUID in the same
scope.

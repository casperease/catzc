# pwsh/Catzc.Base.Timeouts/configs/timeout-exemptions.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `exempt: []`, written with `#`.

```text
Time-safeguard exemptions — work that may run past its normal limit while it is being tuned. Loaded by
Get-Config -Config timeout-exemptions and validated by the TimeoutExemptionsConfig type; read through
Get-TimeoutExemption, Test-IsTimeoutExempt and Assert-IsNotTimeoutExempt.

A piece of work is identified by an immutable budget GUID: minted with ConvertTo-Guid so it spells its name,
registered in pwsh/Catzc.Base.QualityGates/configs/guids.yml, and passed by the call site as -Budget
(Invoke-WithTimeout, Assert-CompletesWithin, Test-CompletesWithin, Get-TimeoutSeconds). Renaming the call site
never changes it.

An exemption never removes the limit: an exempt budget runs up to its scope's ceiling instead.

  ceiling:                                   # optional; the sensible defaults are declared on the type
    <devbox|pipeline>: { pwsh: <s>, bash: <s>, zsh: <s> }
  exempt:
    - single: <guid>                         # exactly one of single | range
      range: { from: <guid>, to: <guid> }    # every GUID from..to inclusive, ordered as written
      scope: { environment: <devbox|pipeline>, shell: <pwsh|bash|zsh> }   # optional; an omitted axis covers every value
      reason: <why it is exempt while it is tuned>

Every GUID here must be a registered, live budget (the exemption integrity test), and no two entries may cover
the same GUID in the same scope.
```

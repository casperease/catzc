# pwsh/Base.Timeouts/types/TimeoutExemptionsConfig.cs

The typed record of the time-safeguard exemptions (`configs/timeout-exemptions.yml`): work, identified by an immutable managed GUID, that
may run past its normal limit while it is being tuned.

## Registration

It is registered in `Catzc.Base.Config/configs/configs.yml` (type `Catzc.Base.Timeouts.TimeoutExemptionsConfig`), so
`Get-Config -Config timeout-exemptions` returns this typed record, and `Get-TimeoutExemption` resolves a budget against it. It mirrors the
YAML keys verbatim
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

An exemption never removes the limit ("ceil all"): an exempt budget runs up to its scope's ceiling instead, at
`ceiling.<devbox|pipeline>.<pwsh|bash|zsh>`, whose sensible defaults are declared on the type, once
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). The
defaults let an exempt budget run up to ten minutes on a devbox and an hour in a pipeline, in every shell. The ceiling is keyed by the
execution engines, declared once
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)).

Each `exempt` entry names its budgets as exactly one of:

- `single: <guid>`, one budget;
- `range: { from: <guid>, to: <guid> }`, every GUID from..to inclusive: a block of minted GUIDs that share a leading group, ordered as
  written (canonical form, ordinal), the same ordering as `Test-IsGuidInRange`.

An entry also takes an optional scope `{ environment: devbox | pipeline, shell: pwsh | bash | zsh }` (an omitted axis covers every value),
and a non-empty reason.

## Validation

Constructing an instance validates the file, collecting every violation into one `ArgumentException`:

- only known keys at every level; every ceiling a positive whole number;
- each entry: exactly one of `single` or `range`, canonical GUIDs that are not the all-zeros GUID, `from` <= `to`, a known scope, a
  non-empty reason;
- no two entries overlap: a GUID matches at most one entry in any (environment, shell) cell.

Whether each GUID is a registered, live budget is the integrity test's job, since the managed-GUID registry lives in another module.

## The exempt list

`exempt` returns the exemptions in file order, each normalized: `from` and `to` (equal for a single), `environments` and `shells` (the
scope, expanded), `reason`, and `kind` (`single` or `range`).

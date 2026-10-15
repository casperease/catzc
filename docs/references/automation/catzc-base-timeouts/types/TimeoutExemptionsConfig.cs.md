---
catzc:
  derived:
    path: docs/references/automation/catzc-base-timeouts/types/TimeoutExemptionsConfig.cs.md
    kind: reference
    body_sha: "9b6d773e44ef"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Timeouts/types/TimeoutExemptionsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The time-safeguard exemptions (configs/timeout-exemptions.yml) — work, identified by an immutable managed GUID, that
may run past its normal limit while it is being tuned. Registered in Catzc.Base.Config/configs/configs.yml (type:
Catzc.Base.Timeouts.TimeoutExemptionsConfig), so Get-Config -Config timeout-exemptions returns this typed record;
Get-TimeoutExemption resolves a budget against it. Mirrors the YAML keys verbatim
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

An exemption never removes the limit ("ceil all"): an exempt budget runs up to its scope's ceiling instead —
ceiling.<devbox|pipeline>.<pwsh|bash|zsh>, whose sensible defaults are declared here, once
([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).
Each `exempt` entry names its budgets as exactly one of
  single: <guid>                         one budget, or
  range: { from: <guid>, to: <guid> }    every GUID from..to inclusive — a block of minted GUIDs that share a
                                         leading group, ordered as written (canonical form, ordinal), the same
                                         ordering as Test-IsGuidInRange;
an optional scope { environment: devbox | pipeline, shell: pwsh | bash | zsh } (an omitted axis covers every value),
and a non-empty reason.

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only known keys at every level; every ceiling a positive whole number;
  - each entry: exactly one of single | range, canonical GUIDs that are not the all-zeros GUID, from <= to, a
    known scope, a non-empty reason;
  - no two entries overlap: a GUID matches at most one entry in any (environment, shell) cell.
Whether each GUID is a registered, live budget is the integrity test's job (the managed-GUID registry lives in
another module).
```

## comment:2

Above `private static readonly string[] Shells = new...`.

```text
The shells a ceiling is keyed by: the execution engines, declared once
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)).
```

## comment:3

Above `private static readonly Dictionary<string, int> Defaults = new...`.

```text
The sensible defaults: an exempt budget may run up to ten minutes on a devbox and an hour in a pipeline, in every
shell.
```

## comment:4

Above `public IReadOnlyList<Hashtable> exempt { get { return entries; } }`.

```text
The exemptions in file order, each normalized: from and to (equal for a single), environments and shells
(the scope, expanded), reason, and kind (single | range).
```

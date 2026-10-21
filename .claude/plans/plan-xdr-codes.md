---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [docs/adr/repository/adr-code-language.md, pwsh/Catzc.Base.Docs/configs/adrs.yml, pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs]
---

# Record-kind codes

A code's first segment names its record kind (`TDR`, `PDR`, `WDR`, `DDR`, `FDR`, `RDR`, and the shared `ADR`), and every parser reads the
kinds from the registry through `AdrsConfig.CodeForm`.

## Why its value is high

The kind tells a reader before opening the record whether it is a thesis, an axiom, a way of working, a design, a flow or an architecture
decision, and each framing citation is one segment shorter than before.

## Open steps

- [ ] `AdrCitationMap.cs` finds a code's domain with `code.IndexOf('-', 4)`, a three-letter kind assumed; it reads the kind's length from
      the code instead, so a two- or four-letter kind keeps working (check: `AdrCitationMap.Tests.ps1` with a widget kind of four letters).
- [ ] `AdrCodeForm.Rule` takes two segments after an owned kind, so an `RDR-DORA-<NAME>` ADR code, whose group segment `DORA` stands where a
      domain segment would, reads as a rule; the grammar learns a kind's group segment from `adrs.yml` (check: `AdrCodeForm.Tests.ps1` with
      a widget kind and group: its ADR code is no rule, its rule code is).

## Open questions

- From catzc-8b's finalize (2026-10-21): a partial edit of `AdrCitationRewriter.cs` broke every session's import for minutes. Should the
  `catzc-verify` skill say that multi-file type work is edited on staged copies under `out/<topic>/staged/` and swapped in by one script
  with a fresh import and a restore on failure? Recommendation: yes, one clause in its import-path step.
- Same finalize: `Update-AdrCitation`'s help still describes numbered rules (`ADR-<CODE>:<n>`, `#<n>` lists) though rules are named. Should
  its page say a rule map row is `old_rule new_rule` of named codes? Recommendation: yes.

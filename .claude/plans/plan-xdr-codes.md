---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets: [docs/adr/repository/adr-code-language.md, pwsh/Catzc.Base.Docs/configs/adrs.yml, pwsh/Catzc.Base.Docs/types/AdrCodeForm.cs]
---

# Record-kind codes

A code's first segment names its record kind. A kind one domain owns stands for that domain and drops its domain segment
(`ADR-DSGN-TRACK-UNORDEREDTRACK` is `DDR-TRACK-UNORDEREDTRACK`); `ADR` stays the shared kind of the implementation domains, which keep their
domain segment (`ADR-AUTO-DEFAULT-ONERESOLUTIONORDER` is unchanged).

## Why its value is high

The framing domains are cited about 3,800 times in about 960 files, each citation one segment longer than its fact needs, and the kind tells
a reader before opening the record whether it is a thesis, an axiom, a way of working, a design, a flow or an architecture decision.

## Decided (the user, 2026-10-21)

| Domain     | Today      | Kind                                   | Example                    |
| ---------- | ---------- | -------------------------------------- | -------------------------- |
| research   | `ADR-DORA` | `RDR-DORA` (Research Decision Record)  | `RDR-DORA-VCS`             |
| thesis     | `ADR-THES` | `TDR` (Thesis Decision Record)         | `TDR-ONETRUTH`             |
| principles | `ADR-PRIN` | `PDR` (Principle Decision Record)      | `PDR-ONELIVE`              |
| process    | `ADR-PROC` | `WDR` (Way-of-working Decision Record) | `WDR-KAIZEN`               |
| design     | `ADR-DSGN` | `DDR` (Design Decision Record)         | `DDR-TRACK-UNORDEREDTRACK` |
| flow       | `ADR-FLOW` | `FDR` (Flow Decision Record)           | `FDR-CD-RUNNER`            |
| the rest   | `ADR-<D>`  | `ADR` (Architecture Decision Record)   | unchanged                  |

- `RDR` keeps `DORA` as a group segment, as ADR-REPO-ADRCODE-ADRSEGMENT groups a vendor framework.
- `docs/adr/`, the `Adr*` commands and types, and the `adr` file names stay in this pass; "decision record" is the umbrella term in prose.
  Their rename is a later plan.

## Open steps

- [ ] The other 30 parsers of the `ADR` marker read the kinds from the registry (`AdrsConfig.Kinds`, a domain's or ruleset's `Prefix`),
      `AdrCodeForm.cs` first, then one file at a time, split with catzc-05 (delegated, 2026-10-21); `declaration.py` and
      `Get-DiagramSupportsDrift.ps1` only after catzc-61's minimap-run go (list: `out/xdr-rename/parser-files.txt` plus those two); one
      widget fixture per new kind (check: each file's tests).
- [ ] The code map for `Update-AdrCitation`: one `move` row per registered framing code (487) and per domain code (6, `ADR-THES` to `TDR`
      and so on), each `new_path` the ADR's own file; the rule map is the header only (check: `out/xdr-rename/dryrun.ps1` with the real map
      matches the proxy-map dry run: 4,587 changes in 826 files, 0 throws, 6 Unhandled numbered test fixtures).
- [ ] The rewrite, one domain per burst with hold/go, after the orchestrator's go: the ADR pages (titles, `## Rules:`, `### Rule`), every
      citer, and the domain's flip in `adrs.yml` (`kind:` its own, `code:` dropped) in the same burst; derived heads regenerated with
      `Format-FileMeta`, `Build-AdrIndex` and `Build-AdrCodeDictionary`. Sizes: THES 224 changes in 73 files, PRIN 581/201, PROC 217/17,
      DSGN 1,457/326, FLOW 1,683/319, DORA 419/42 (check: `Test-Links`, `Test-AdrRegistry`, `Test-GeneratedFiles`).
- [ ] Prose wildcards (`ADR-DSGN-*`), diagram `diagram.drawio.yml` subtitles and legends re-rendered, `glossary.yml`, `agents.yml`,
      `capabilities.yml`, `.claude/CLAUDE.md`, by hand one file at a time: 22 lines naming a bare domain code in 6 files and 9 wildcards
      (check: no `ADR-(THES|PRIN|PROC|DSGN|FLOW|DORA)` left; the frozen `contracts/EXTERNAL-azure/0.1.0` cites only REPO rules, so it needs
      no exemption, delegated 2026-10-21).

## Open questions

- From catzc-8b's finalize (2026-10-21): a partial edit of `AdrCitationRewriter.cs` broke every session's import for minutes. Should the
  `catzc-verify` skill say that multi-file type work is edited on staged copies under `out/<topic>/staged/` and swapped in by one script
  with a fresh import and a restore on failure? Recommendation: yes, one clause in its import-path step.
- Same finalize: `Update-AdrCitation`'s help still describes numbered rules (`ADR-<CODE>:<n>`, `#<n>` lists) though rules are named. Should
  its page say a rule map row is `old_rule new_rule` of named codes? Recommendation: yes, rewritten with this plan's kind step.

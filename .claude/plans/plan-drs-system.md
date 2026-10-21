---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/adr,
      pwsh/Catzc.Base.Docs/configs/adrs.yml,
      pwsh/Catzc.Base.Docs/types/AdrsConfig.cs,
      docs/adr/repository/adr-code-language.md,
      pwsh/Catzc.Base.Docs/configs/glossary.yml,
    ]
---

# Decision Records System

The **Decision Records System (DRS)** is the one system that holds every decision record: the record-kind domains (`RDR`, `TDR`, `PDR`,
`WDR`, `DDR`, `FDR`, and the shared `ADR` of the implementation domains, together "XDR"), their rules, the index and the registry. Its home
is `docs/drs/`; `docs/adr/` names one kind for a folder that holds seven.

## Why its value is high

Since the record-kind codes landed (2026-10-21), the folder name, the index title and the umbrella word "ADR" say one kind where the tree
holds seven: a reader who meets `docs/adr/principles/one-living-version.md` with a `PDR-ONELIVE` code reads two names for one thing. The
move touches `docs/adr` in 3,194 places in 1,206 files and a relative `../adr/` link in 697 files, so it is one planned burst after the root
is declared once, not a sweep.

## Decided (the user, 2026-10-21)

- The system is named **DRS**, the Decision Records System; it lives in `docs/drs/` and holds the XDR record-kind domains and their rules.
- The record kinds and their codes are unchanged: `ADR` stays the shared kind of the implementation domains.
- Every `Adr*` name is system-level, so each takes `Drs`: `Test-DrsRegistry`, `Build-DrsIndex`, `Update-DrsCitation`, `DrsConfig`,
  `drs.yml`, `drs-index.yml`, `drs-checks.yml`, `analyzer-drs-map.yml`, the `drs-reviewer` agent and the `drs-cite` skill.
- The DRS commands and types leave `Catzc.Base.Docs` for their own module, `Catzc.Base.Drs`, in the same step as the rename, so each file
  moves and is renamed once.
- The grammar record `ADR-REPO-ADRCODE` (`adr-code-language.md`) becomes `ADR-REPO-DRSCODE` (`drs-code-language.md`), re-cited in the move's
  burst.
- In prose, "decision record" names one record, "the DRS" the system, and "ADR" only the `ADR` kind; the sanctioned pair is "domain rules /
  DRS rules".

## Order

The record-kind rewrite has landed, so the steps run in order; the move is one burst after the user's go.

## Open steps

- [ ] `docs/adr/repository/adr-code-language.md`: a rule naming the DRS, `docs/drs/` its one root, every record of one registered kind, the
      kinds together "XDR" (check: `Test-AdrRegistry`, `Test-Links` on the file).
- [ ] `pwsh/Catzc.Base.Docs/configs/glossary.yml`: entries for **DRS**, **decision record** and **record kind**, each defined by the new
      rule; `domain rules` reads "its decision records and the rules they state", avoid `house rules` say `domain rules / DRS rules` (check:
      `Test-Glossary`, `Build-Glossary`).
- [ ] `pwsh/Catzc.Base.Docs/types/AdrsConfig.cs` and `adrs.yml`: a `root` key, its default `docs/adr` declared once on the type, and every
      caller reads it instead of its literal: `Build-AdrCodeDictionary`, `Build-AdrIndex`, `Build-Glossary`, `Get-AdrCitationMap`,
      `Get-CatsAdrRuleIds`, `Show-Cats`, `Test-AdrEngineNeutrality`, `Test-AdrRegistry`, `Update-AdrCitation`, the five
      `private/Get-Adr*Violations` messages, `AdrCitationRewriter.cs`'s `AdrRoot`, and `readme.yml`'s two rows; type and callers in one pass
      on staged copies, a fresh full import right after (check: the `Catzc.Base.Docs` Pester; `git grep "docs/adr" -- pwsh` finds only the
      type default and comments).
- [ ] `out/drs/dryrun.ps1`: `Update-AdrCitation -DryRun` with one folder `move` row `docs/adr` -> `docs/drs` (two segments, never a
      one-segment folder row) (check: about 3,194 repository-rooted and 697-file relative rewrites, 0 throws, the counts written into this
      step before the next).
- [ ] The move, one burst after the user's go: `docs/adr/` moved to `docs/drs/` on disk (the user commits), the rewrite from the dry run's
      map plus one ADR row `ADR-REPO-ADRCODE` -> `ADR-REPO-DRSCODE` with the file renamed `drs-code-language.md`, the `root` default flipped
      to `docs/drs`, then `Build-AdrIndex`, `Build-AdrCodeDictionary`, `Build-Glossary` and `Format-FileMeta` (check: `Test-Links`,
      `Test-AdrRegistry`, `Test-GeneratedFiles`, `Test-FileMeta`).
- [ ] `pwsh/Catzc.Base.Docs/configs/adr-index.yml`: the index titled "DRS index and rule-citation registry", its preamble saying the DRS
      holds the record-kind domains (check: `Build-AdrIndex`, `Test-GeneratedFiles`).
- [ ] By hand, one file at a time: the four `.claude/hooks/` files that name `docs/adr` (each hook rebuilt), `agents.yml`,
      `capabilities.yml`, and every `diagram.drawio.yml` naming `docs/adr`, re-rendered (check: `git grep -n "docs/adr"` finds nothing).
- [ ] `.claude/CLAUDE.md`, the user's edit: the structure line and the `## ADRs` section become `docs/drs/` and `## DRS`, "read
      `docs/drs/index.md`", "domain rules / DRS rules" (check: `Test-Links` on the file).
- [ ] `pwsh/Catzc.Base.Drs/`: the new module; every DRS command, private function, type, config and test moves out of `Catzc.Base.Docs`
      (about 50 files) and `Catzc.Base.QualityGates` (`Get-AdrUsage`, `Test-AnalyzerAdrMap` and their helpers) on disk, renamed `Drs` as it
      moves, its callers in the same pass, staged copies swapped in by one script with a fresh full import and a restore on failure (check:
      the module's Pester, `Test-ParameterConsistency`, a fresh `. ./importer.ps1`).
- [ ] `contracts/catzc/0.0.0/`: the three command contracts (`test_adr_registry`, `test_adr_engine_neutrality`, `test_analyzer_adr_map`)
      renamed with their commands under `catzc.base.drs` (check: `Test-Contracts`).
- [ ] `.claude/agents/adr-reviewer.md` -> `drs-reviewer.md` and `.claude/skills/adr-cite/` -> `drs-cite/`, their rows in `agents.yml` and
      `capabilities.yml` and every agent that loads them (check: `Test-AgentDefinitions`).
- [ ] The prose sweep, one domain per burst: "ADR" as the umbrella becomes "decision record" or "the DRS", kept only where it names the
      `ADR` kind, in `docs/drs/`, `docs/explanation/`, `docs/how-to/` and the glossary sources (check: `Test-Terminology`, `Test-Glossary`,
      `Test-Links`).

## Refs

- `.claude/CLAUDE.md` is dirty in a peer's change; its step waits for that change to land.

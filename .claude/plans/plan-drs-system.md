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

- `Catzc.Base.Drs` depends on nothing above it (delegated, 2026-10-21): `Format-MarkdownParagraph` moves down to `MarkdownMeta`; the usage
  report and the analyzer map stay in `QualityGates`, renamed in place, since they call `Get-FileMetaScope` there and `CodeMeta` reads no
  config and no file; the glossary and `Show-Cats` stay in `Docs`.

## Order

The record-kind rewrite has landed, so the steps run in order; the move is one burst after the user's go.

## Open steps

- [ ] `docs/adr/repository/adr-code-language.md`: a rule naming the DRS, `docs/drs/` its one root, every record of one registered kind, the
      kinds together "XDR" (check: `Test-AdrRegistry`, `Test-Links` on the file).
- [ ] `pwsh/Catzc.Base.Docs/configs/glossary.yml`: entries for **DRS**, **decision record** and **record kind**, each defined by the new
      rule; `domain rules` reads "its decision records and the rules they state", avoid `house rules` say `domain rules / DRS rules` (check:
      `Test-Glossary`, `Build-Glossary`).
- [ ] The root readers outside `Catzc.Base.Docs` read `AdrsConfig.Root` (Python: `adrs.yml`'s `root`, default `docs/adr`), staged, one
      burst: `CodeLinkRewriter.cs` (its path pattern and `ToRepositoryPath`), `LinkEngine.cs` (`StringDocPath`, `InsertedLink`), the
      `LanguagesConfig.cs` message, `Build-ContractReference.ps1`'s two relative links, the `Get-TestTagViolations` and
      `Test-AnalyzerAdrMap` messages, and `minimaps.py` and `drawio_forward.py` (check: `Test-Links.Tests`, `Format-Links.Tests`,
      `Build-ContractReference.Tests`, the `catzc_diagrams` pytest; `out/drs/residual.txt` rerun finds only comments, fixtures, pages and
      config data).
- [ ] The move, one burst after the user's go: the rewrite of `out/drs/dryrun.ps1` written (its code map `out/drs/root-code-map.tsv`, one
      row of kind `root`, `docs/adr` -> `docs/drs`) plus one ADR row `ADR-REPO-ADRCODE` -> `ADR-REPO-DRSCODE` with the file renamed
      `drs-code-language.md`, then `docs/adr/` moved to `docs/drs/` on disk (the user commits), the `root` default flipped to `docs/drs`,
      then `Build-AdrIndex`, `Build-AdrCodeDictionary`, `Build-Glossary` and `Format-FileMeta`. The dry run (2026-10-21): 6,963 rewrites in
      1,911 of 1,985 files that name the root, 0 throws, 3,109 repository-rooted (1,435 path mentions, 1,674 links) and 3,854 relative
      (3,846 links, 8 path mentions); the 31 Unhandled are the numbered fixtures every run reports. 21 files name the root as a literal no
      rewrite reaches (code strings and folder mentions, `readme.yml`, `GlossaryOptions.cs`'s `docs/adr/research/**`, the type default):
      `out/drs/dryrun.ps1` lists them, and they change by hand in the same burst (check: `Test-Links`, `Test-AdrRegistry`,
      `Test-GeneratedFiles`, `Test-FileMeta`, `git grep -n "docs/adr"` finds nothing).
- [ ] `pwsh/Catzc.Base.Docs/configs/adr-index.yml`: the index titled "DRS index and rule-citation registry", its preamble saying the DRS
      holds the record-kind domains (check: `Build-AdrIndex`, `Test-GeneratedFiles`).
- [ ] By hand, one file at a time: the four `.claude/hooks/` files that name `docs/adr` (each hook rebuilt), `agents.yml`,
      `capabilities.yml`, and every `diagram.drawio.yml` naming `docs/adr`, re-rendered (check: `git grep -n "docs/adr"` finds nothing).
- [ ] `.claude/CLAUDE.md`, the user's edit: the structure line and the `## ADRs` section become `docs/drs/` and `## DRS`, "read
      `docs/drs/index.md`", "domain rules / DRS rules" (check: `Test-Links` on the file).
- [ ] `pwsh/Catzc.Base.MarkdownMeta/`: `Format-MarkdownParagraph` moves down from `Catzc.Base.Docs` with its test and page, its callers
      unchanged, so `Catzc.Base.Drs` never depends on `Docs` (check: its Pester, a fresh `. ./importer.ps1`).
- [ ] `pwsh/Catzc.Base.Drs/`: the new module; the 63 `Adr*` files of `Catzc.Base.Docs` (commands, privates, types, configs, tests, assets)
      move on disk, renamed `Drs` as they move, namespace `Catzc.Base.Drs`, with their code callers, `configs.yml`'s 3 type rows and the
      `dependencies.yml` edges in the same pass; staged copies swapped in by one script with a fresh full import and a restore on failure.
      Re-run `out/drs/prep/inventory.sh` and `callers.ps1` first; `out/drs/prep/module-move.md` holds the list and the edges (check: the
      module's Pester, `Test-ParameterConsistency`, a fresh `. ./importer.ps1`).
- [ ] `pwsh/Catzc.Base.QualityGates/`: the usage report and the analyzer map (`Get-AdrUsage`, `Get-AdrUsageRow`, `Group-AdrUsage`,
      `Get-AdrCitationPath`, `Get-AdrDefinedRule`, `Get-AdrCodesFileMetaFact`, `Test-AnalyzerAdrMap`, `Get-AnalyzerAdrCoverage`,
      `AnalyzerAdrMapConfig`, `analyzer-adr-map.yml`, their tests) renamed `Drs` in place (check: their Pester,
      `Test-ParameterConsistency`).
- [ ] `contracts/catzc/0.0.0/`: `test_adr_registry` and `test_adr_engine_neutrality` renamed with their commands under `catzc.base.drs`,
      `test_analyzer_adr_map` renamed in place under `catzc.base.quality_gates` (check: `Test-Contracts`).
- [ ] `.claude/agents/adr-reviewer.md` -> `drs-reviewer.md` and `.claude/skills/adr-cite/` -> `drs-cite/`, their rows in `agents.yml` and
      `capabilities.yml` and every agent that loads them (check: `Test-AgentDefinitions`).
- [ ] The prose sweep's clear patterns, after the move (the user, 2026-10-21; counts in `out/drs/prep/renames-and-prose.md`): first the
      section heading `## Where the code and the ADR differ` in 93 explanation pages becomes
      `## Where the code and the decision record     differ`, with its anchors re-pointed; then the 143 system words ("ADR index / registry
      / rules / domain" -> "DRS …"), the 129 uses in framing-domain records (-> the record's kind or "decision record") and the 116 plurals
      meaning the corpus (-> "decision records"); the generated `index.md` and `glossary.md` through `adr-index.yml` and the `glossary.yml`
      sources; the 319 implementation-domain self-references stay, as they name the `ADR` kind (check: `Test-Links` after the heading pass,
      then `Test-Terminology`, `Test-Glossary`, `Test-Links`).
- [ ] The 381 singular uses of "ADR" outside the records (explanation, how-to, the glossary sources), one domain per step, each sentence
      read by a worker: "decision record" where it means the umbrella, "ADR" kept where it names an `ADR`-kind record (check: per domain,
      `Test-Terminology` and `Test-Links`).

## Refs

- `.claude/CLAUDE.md` is dirty in a peer's change; its step waits for that change to land.

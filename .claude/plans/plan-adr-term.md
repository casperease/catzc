---
plan:
  status: active
  value: high
  reviewed: 2026-10-27
  class: meta
  targets:
    [
      pwsh/Base.Drs,
      pwsh/Base.Maps,
      pwsh/Base.Docs,
      pwsh/Base.Slides,
      pwsh/Base.Languages,
      pwsh/Base.QualityGates,
      pwsh/Base.Globs,
      pwsh/Tooling.Listen,
      python/diagrams,
      docs,
      contracts,
      .claude,
    ]
---

# ADR names only the ADR kind

## Why high

"ADR" is the kind of the implementation domains' records (the user, 2026-10-27); the system is the DRS and a record of any kind is a
decision record. The tree still says "ADR" for the whole: the inventory of 2026-10-27 (tracked files, `.unordered/` and `.claude/learnings/`
skipped) found 1,605 generic prose uses in 499 files, 1,307 identifier parts in 440 files, 85 lines in 6 generated files and 9 tracked
paths, against 327 genuine ADR-kind uses and 14,024 rule-code occurrences, which stay. Every reader of `docs/drs/index.md`, every robot
brief and every message meets the wrong word first.

## Decided

- Prose: "the DRS" for the system, "decision record" or "DRS record" for a record of any kind, "rule" for a rule code, "domain" for a DRS
  domain. "ADR" stays only for the `ADR` kind: as the mention `ADR` or "an `ADR` record".
- Rule codes (`ADR-*`, `#rule-adr-*` anchors, slide files named by a lower-cased code) are never touched here.
- Identifiers follow one scheme, the one `Catzc.Base.Drs` started (`DrsCodeForm`, `Get-DrsRuleIds`): the system is `Drs`, one record is
  `Record`, a list of codes a thing cites is `rules` (a record or domain code selects its rules, ADR-REPO-DRSCODE-CODEISSELECTOR), the
  rule-code spelling category is `rule-code`. Renames: `$adrs`/`$adrs.Root` (the drs config) -> `$drs`; `adrRoot`/`$adrDocsRoot` ->
  `drsRoot`; `Form.AdrRelative` -> `Form.DrsRelative`; `adr_folder` (languages.yml, `FileLanguage`) -> `drs_folder`; `adrPath`/`$adrFile`/
  `adrFiles`/`newAdrPath` -> `recordPath`/`$recordFile`/`recordFiles`/`newRecordPath`; `AdrId`/`AdrOf`/`ParentAdr`/`ForAdr`/`*ByAdr` ->
  `RecordId`/`RecordOf`/`ParentRecord`/`ForRecord`/`*ByRecord`; `AdrCount`/`adr_count`/`cell.Adrs` -> `RecordCount`/`record_count`/
  `cell.Records`; `BasisAdrFile` -> `BasisRecordFile`; `value_chain_legend_adrs` -> `value_chain_legend_records`; the file-kind and
  link-direction class `adr` and the listen `Kind` `adr` -> `record`; the `about.adrs` diagram key -> `about.rules`; the `-Adr` parameter of
  the `Catzc.Base.Maps` commands -> `-Rule`; `Get-AdrRuleText` -> `Get-DrsRuleText`; `Write-AdrFixture` -> `Write-RecordFixture`; the
  `Show-Catzc adr` topic -> `drs`; `terminology/adr.yml`, `adr-example.yml`, `cspell/adr.txt` and the `catzc-terms-adr` dictionaries ->
  `rule-code`; `add-an-adr.md` -> `add-a-decision-record.md`; `manual-test-plan/adr-registry.md` -> `drs-registry.md`.
- A generated file is fixed at its generator and rebuilt, never edited: `docs/drs/index.md` (`drs-index.yml`, `Build-DrsIndex`),
  `docs/drs/glossary.md` (`Build-Glossary`), `docs/references/contracts/catzc.md` (the command contracts, `Build-ContractReference`),
  `.claude/agents/*.md` (their registry source), `pwsh/.internal/assets/importer-commands.sh` and `.gitattributes` (their generators).
- `.claude/CLAUDE.md` says "decision records" for the system (the user, 2026-10-27).
- An ADR-kind record names itself by its domain too (the user, 2026-10-27): its "# ADR: …" title takes the domain word the way the other
  kinds take "# Design:" and "# Principle:", and its "This ADR" becomes "this record", so the gate needs no folder excludes.
- A generic rule name takes the record form (the user, 2026-10-27), as ADR-REPO-DRSCODE-RECORDSEGMENT does, each segment at most 24
  characters.

## Open steps

"The Grep above" below means a Grep for a bare word ADR or ADRs (no hyphen, no backtick next to it), every hit a kind mention.

### The generators and the record titles

- [ ] The ADR-kind records under `automation/`, `configuration/`, `ado/`, `github/`, `azure/` and `repository/`: each "# ADR: …" title takes
      its domain word ("# Automation:", "# Repository:", "# Azure:", per the DRS conventions) and each "This ADR" says "this record", one
      record at a time, at most 15 records per drone brief. Check: `Test-DrsRegistry`, `Test-Links`, `Test-Spelling`, `Test-Glossary` after
      every 15 records.

### Code, one module per step, by staged burst

Each step renames the module's identifiers per the scheme above, its comments and messages in the same pass, its contract and every in-tree
caller in the same change (PDR-ONELIVE); a module on the importer path (`Catzc.Base.Drs`, `Catzc.Base.Docs`, `Catzc.Base.Languages`,
`Catzc.Base.Globs`, every `types/*.cs`) lands by `Invoke-StagedBurst` with `Test-Parsing` first and a fresh full import after.

- [ ] `pwsh/Base.Drs/Update-DrsCitation.ps1` and `pwsh/Base.Drs/tests/Update-DrsCitation.Tests.ps1`: the `Drs`/`Record` renames (`$adrRoot`,
      `$adrFile`). Check: `Invoke-TestFile` on that test file, `Test-DrsRegistry`.
- [ ] `python/diagrams` leftovers of the Base.Slides step: the `drawio_forward.py` identifiers (`ADR_CODE`, `known_adrs`, `adrs_of`, the
      `adrs` locals), the `adrs` locals in `declaration_get.py` and `declaration_get_action.py`, the generic ADR prose in
      `python/diagrams/assets/STYLE.md` and `python/diagrams/assets/slides/STYLE.md`, and the text of `template-slide.xml`. Each edit by
      hand, one file at a time. Check: `Invoke-PythonTest` on `python/diagrams`.
- [ ] `pwsh/Base.Maps` leftovers: the generic ADR test names and `$adr` locals in the value-chain tests (`ValueChainMap`,
      `ValueChainHighlight`, `MinimapData`, `Test-ValueChainMap`, `Get-ValueChainMap` `.Tests.ps1`), one file at a time. Check:
      `Invoke-TestFile` on each touched test file.

### Prose, one area per step

- [ ] `docs/drs/` (182 generic uses in 49 records; most in `repository/` drs-code-language, markdown-links, links-in-repository,
      controlled-vocabulary and the `dora-explains.md` files): reword per the decided words, keeping ADR-kind self-reference. Check: the
      Grep above over `docs/drs`, every hit a kept use; `Test-Links`, `Test-Spelling` on the touched records.
- [ ] `docs/references/` leftovers: `pwsh/base-drs/update-drs-citation.md` with the Update-DrsCitation step, and "checked ADR domains" in
      `contracts/catzc/0.1.0/pwsh.base.drs/test_drs_engine_neutrality.command.yml` -> "checked DRS domains", then `Build-ContractReference`
      rebuilds `contracts/catzc.md`. Check: the Grep over `docs/references`, `Test-Links`.
- [ ] `docs/explanation/` leftovers inside the diagram declarations: the titles of `automation/rule-and-gate-per-load-stage.md` and
      `azure/coordinate-rules-and-their-gates.md` (h1, lead line, `yml drawio` title, png alt; re-render with the title), the `description:`
      lines of `design/a-sibling-is-an-idea-never-a-reference.md`, `design/which-rung-gates-exist-in-code.md`,
      `flow/drift-is-gated-generation-is-drs-only.md`, `flow/gates-check-source-and-trigger.md`,
      `flow/one-gate-checks-the-raw-read-rule.md`, and the link class `kind: adr` -> `kind: record` in every `yml drawio` block. Check: the
      Grep over `docs/explanation`, `Test-Links`.
- [ ] `.claude/skills/catzc-module/SKILL.md` ("an ADR the code cites" and `ADR-<DOMAIN>-<ADR>-<RULE>` -> `ADR-<DOMAIN>-<RECORD>-<RULE>`) and
      `.claude/skills/plan-orchestrate/SKILL.md` ("the governing ADRs"), both dirty from a peer when the rest landed, `.claude/plans/*.md`
      (the stale `Update-AdrCitation` -> `Update-DrsCitation`). Check: `Test-AgentDefinitions`, `Test-Plans`.

### The gate, last

- [ ] `pwsh/Base.Drs/configs/glossary.yml` (new source, `Catzc.Base.Drs` owns the DRS): the concept `architecture decision record` (key
      `adr`, domain `repository`, `defined_by: ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM`, which bolds it once the rule step lands,
      `realized_by: { kind: prose-only }`), with
      `avoid: [{ phrase: ADR, say: "decision record / DRS record; the DRS for the system; the kind in backticks" }, { phrase: ADRs, say: decision records }]`
      and no folder excludes; and `pwsh/Base.Docs/configs/glossary/repository.yml` drops the `ADR system` avoid it subsumes. Check:
      `Test-Glossary` reports 0 issues, `Build-Glossary`.
- [ ] The identifier half: `pwsh/Base.RootConfig/assets/root/cspell-template.yml` gains `flagWords: [adr, adrs]` with an `ignoreRegExpList`
      entry for the rule codes (`(?:ADR|TDR|PDR|WDR|DDR|FDR|EDR)(?:-[A-Z0-9*<>]+)+`), the `#rule-adr-` anchors and the code-named slide
      files, a HOLD first. Check: a scratch word list through `cspell stdin` flags `adrRoot` and passes `ADR-AUTO-TEST-ONECATEGORY`, then
      `Test-Spelling` reports 0 issues.

## Refs

- Inventory rows (scratch, regenerable): `out/adrterm/rows.csv`, `out/adrterm/kind-area.txt`, `out/adrterm/identifiers.txt`, by
  `out/adrterm-inventory.ps1`.
- [drs-code-language](../../docs/drs/repository/drs-code-language.md),
  [controlled-vocabulary](../../docs/drs/repository/controlled-vocabulary.md), [plans](../../docs/drs/repository/plans.md).

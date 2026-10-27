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
- The five generic rule names take the record form (the user, 2026-10-27): NEWFOLDERNEEDSADR, ADRSEGMENT, CATZCADRSDECIDE,
  ADRSLINKGROUNDINGONLY and ANALYZERADRMAPPING, re-cited by `Update-DrsCitation` with its dry run first, each segment at most 24 characters.

## Open steps

### The DRS index first

- [ ] `pwsh/Base.Drs/configs/drs-index.yml`: the preamble and the authoring conventions say "decision record", "record" and "the DRS" for
      every generic "ADR" ("The ADRs define", "Every ADR carries", "every ADR of the domain", "code ↔ ADR mapping", "writing or editing any
      ADR", "An ADR owns", "code to ADR", "one entry per ADR"), keeping the `ADR` kind mentions and the rule codes; and
      `pwsh/Base.Drs/Build-DrsIndex.ps1`: the table's second column header `'ADR'` becomes `'Record'` and the throw says "no single decision
      record file" (`Get-DrsIndex` matches rows, never the header). Check: `Invoke-TestFile` on
      `pwsh/Base.Drs/tests/Build-DrsIndex.Tests.ps1`, `Build-DrsIndex`, then a Grep of `docs/drs/index.md` for a bare word ADR or ADRs (no
      hyphen, no backtick next to it) finds only the kind mentions; "the Grep above" below means this search.

### The rule and the other generators

- [ ] `docs/drs/repository/drs-code-language.md`: ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM's summary states that "ADR" names only the `ADR`
      kind, the system is the DRS and a record of any kind is a decision record (ADR-REPO-PLANS-DECISIONSBECOMERULES). Check:
      `Test-DrsRegistry`, `Test-Glossary`.
- [ ] `pwsh/Base.Docs/Build-Glossary.ps1`: the page note says "the one DRS rule that defines it". Check: `Invoke-TestFile` on
      `pwsh/Base.Docs/tests/Build-Glossary.Tests.ps1`, `Build-Glossary`, a Grep of `docs/drs/glossary.md` as above.
- [ ] `contracts/catzc/0.1.0/pwsh.base.drs/*.command.yml` descriptions ("the ADR registry", "the ADR rule files") say "the DRS registry" and
      "the decision records", keeping "the configured `ADR` domains" of `test_drs_engine_neutrality`. Check: `Test-Contracts`,
      `Build-ContractReference`, a Grep of `docs/references/contracts/catzc.md` as above.
- [ ] The agents' registry source in `pwsh/Base.Docs` (behind `.claude/agents/drone-*.md`, "then in full the ADRs that govern") says "the
      decision records that govern". Check: `Test-AgentDefinitions`, a Grep of `.claude/agents` as above.
- [ ] The generators of `pwsh/.internal/assets/importer-commands.sh` and `.gitattributes` carry no generic "ADR". Check: rebuild each, a
      Grep of both files as above.

### Code, one module per step, by staged burst

Each step renames the module's identifiers per the scheme above, its comments and messages in the same pass, its contract and every in-tree
caller in the same change (PDR-ONELIVE); a module on the importer path (`Catzc.Base.Drs`, `Catzc.Base.Docs`, `Catzc.Base.Languages`,
`Catzc.Base.Globs`, every `types/*.cs`) lands by `Invoke-StagedBurst` with `Test-Parsing` first and a fresh full import after.

- [ ] `pwsh/Base.Languages` (`FileLanguage.cs`, `LanguagesConfig.cs`, `configs/languages.yml`, its tests and `Get-FileLanguage.Tests.ps1`)
      and `contracts/catzc/0.1.0/pwsh.base.languages/types.json`: `adr_folder` -> `drs_folder`, every reader of the key with it. Check:
      `Invoke-TestFile` on `pwsh/Base.Languages/tests/types/LanguagesConfig.Tests.ps1` and `Get-FileLanguage.Tests.ps1`, `Test-Contracts`.
- [ ] `pwsh/Base.Globs/configs/file-kinds.yml`, `contracts/catzc/0.1.0/pwsh.base.globs/file-kinds.yml`,
      `pwsh/Base.QualityGates/configs/link-directions.yml`, `pwsh/Tooling.Listen` and `.claude/skills/listen-tiers/SKILL.md`: the class and
      kind `adr` -> `record`, in one burst since the class crosses all four. Check: `Invoke-TestFile` on
      `pwsh/Base.Globs/tests/Get-FileKind.Tests.ps1`, `pwsh/Tooling.Listen/tests/Get-DocChange.Tests.ps1`, `Find-DocPattern.Tests.ps1`,
      `Get-DocNote.Tests.ps1`, `Test-LinkDirections`.
- [ ] `pwsh/Base.Drs` (`DrsCitationRewriter.cs`, `DrsCitationMap.cs`, `DrsDoraCheck.cs`, `DrsCodeForm.cs` comments, `Build-DrsIndex.ps1`,
      `Build-DrsCodeDictionary.ps1`, `Get-DrsCitationMap.ps1`, `Test-DrsRegistry.ps1`, the privates and the tests with `Write-AdrFixture`):
      the `Drs`/`Record` renames. Check: `Invoke-TestFile` on each touched test file under `pwsh/Base.Drs/tests`, `Test-DrsRegistry`.
- [ ] `pwsh/Base.Maps` (`ValueChainMap.cs`, `ValueChainCell.cs`, `ValueChainHighlight.cs`, `WorldMap*.cs`, `MapsConfig.cs`, `MapsLabels.cs`,
      `MapsPin.cs`, `CitationScanner.cs`, `configs/maps.yml`, the `-Adr` commands, `Export-WorldMapPdf.ps1`, the tests) and
      `contracts/catzc/0.1.0/pwsh.base.maps/*`: `-Adr` -> `-Rule`, the pin key `adr` -> `rule`, the `Record` renames,
      `value_chain_legend_adrs` -> `value_chain_legend_records`. Check: `Invoke-TestFile` on each touched test file under
      `pwsh/Base.Maps/tests`, `Test-Contracts`, `Test-ValueChainMap`.
- [ ] `pwsh/Base.Slides` (`Get-AdrRuleText.ps1` -> `Get-DrsRuleText.ps1`, `Write-DiagramMinimapData.ps1`, `Get-DiagramSupportsDrift.ps1`,
      `Get-SlideFinding.ps1` message, tests), `python/diagrams` (`minimaps.py`, `drawio_forward.py`, the `declaration_*.py` files,
      `assets/STYLE.md`, `glyphs.xml`, `template-slide.xml`, the tests and samples) and every diagram declaration under `docs/`
      (`about.adrs` -> `about.rules`, by `Rename-CodeName` with its dry run first, never a script): one burst, since the key crosses both
      readers. Check: `Invoke-TestFile` on the touched `pwsh/Base.Slides/tests` files, `Invoke-PythonTest` on `python/diagrams`,
      `Test-Diagrams`.
- [ ] `pwsh/Base.Docs` (`Show-Catzc.ps1` topic `adr` -> `drs` and its messages, `Get-Glossary*` tests' fixtures) and
      `docs/references/pwsh/base-docs/show-catzc.md`. Check: `Invoke-TestFile` on the touched `pwsh/Base.Docs/tests` files.
- [ ] `pwsh/Base.QualityGates` (`configs/terminology/adr.yml` -> `rule-code.yml`, `adr-example.yml` -> `rule-code-example.yml`, their
      category keys, `CodeLinkRewriter.cs`, `LinkEngine.cs`, `Test-AnalyzerDrsMap.ps1` message, `configs/analyzer-drs-map.yml` comments, the
      tests) and `pwsh/Base.RootConfig/assets/root/cspell-template.yml` with `.cspell/.gitignore` (the `catzc-terms-adr` dictionaries ->
      `catzc-terms-rule-code`; a root asset, so a HOLD to every live peer first). Check: `Invoke-TestFile` on the touched
      `pwsh/Base.QualityGates/tests` files, `Test-Terminology`, `Test-Spelling`.
- [ ] The remaining single-file modules (`pwsh/Base.Flow` `RungsConfig` message, `pwsh/Base.Git`,
      `pwsh/Base.Variants/configs/track-types.yml`, `pwsh/Base.CodeMeta`, `pwsh/Base.MarkdownMeta`,
      `pwsh/Base.TypesSystem/assets/Catzc.Types.csproj.xml` with `pwsh/.internal/assets/Catzc.Types.csproj`, `pwsh/.scriptanalyzer`,
      `pwsh/Azure.Templates`), each with its test file. Check: `Invoke-TestFile` on each module's touched test file.

### Prose, one area per step

- [ ] `docs/drs/` (182 generic uses in 49 records; most in `repository/` drs-code-language, markdown-links, links-in-repository,
      controlled-vocabulary and the `dora-explains.md` files): reword per the decided words, keeping ADR-kind self-reference. Check: the
      Grep above over `docs/drs`, every hit a kept use; `Test-Links`, `Test-Spelling` on the touched records.
- [ ] `docs/references/` by module folder (681 uses in 185 pages; `dora/capabilities.md` "Repo ADR" -> "Repo record", `base-drs/`,
      `base-maps/`, `BCL/index.md`), each comment page with its code's step when it names a renamed identifier. Check: the Grep over each
      folder, `Test-Links`.
- [ ] `docs/explanation/` (102 uses in 43 articles), `docs/how-to/` (18 uses; the two renamed how-to pages with every link to them) and
      `docs/index.md` ("## Automation ADRs"). Check: the Grep over each folder, `Test-Links`.
- [ ] `.claude/skills/*/SKILL.md` (12 uses in 7 skills, `catzc-module`'s "an ADR the code cites" and `ADR-<DOMAIN>-<ADR>-<RULE>` ->
      `ADR-<DOMAIN>-<RECORD>-<RULE>`), `.claude/plans/*.md` (the stale `Update-AdrCitation` -> `Update-DrsCitation`). Check:
      `Test-AgentDefinitions`, `Test-Plans`.

### The gate, last

- [ ] `pwsh/Base.Drs/configs/glossary.yml` (new source, `Catzc.Base.Drs` owns the DRS): the concept `architecture decision record` (key
      `adr`, domain `repository`, `defined_by: ADR-REPO-DRSCODE-DECISIONRECORDSSYSTEM`, which bolds it once the rule step lands,
      `realized_by: { kind: prose-only }`), with
      `avoid: [{ phrase: ADR, say: "decision record / DRS record; the DRS for the system; the kind in backticks" }, { phrase: ADRs, say: decision records }]`
      and
      `options: { exclude: [docs/drs/automation/**, docs/drs/configuration/**,     docs/drs/ado/**, docs/drs/github/**, docs/drs/azure/**, docs/drs/repository/**] }`,
      the ADR-kind records whose own "ADR" is kept; and `pwsh/Base.Docs/configs/glossary/repository.yml` drops the `ADR system` avoid it
      subsumes. Check: `Test-Glossary` reports 0 issues, `Build-Glossary`.
- [ ] The identifier half: `pwsh/Base.RootConfig/assets/root/cspell-template.yml` gains `flagWords: [adr, adrs]` with an `ignoreRegExpList`
      entry for the rule codes (`(?:ADR|TDR|PDR|WDR|DDR|FDR|EDR)(?:-[A-Z0-9*<>]+)+`), the `#rule-adr-` anchors and the code-named slide
      files, a HOLD first. Check: a scratch word list through `cspell stdin` flags `adrRoot` and passes `ADR-AUTO-TEST-ONECATEGORY`, then
      `Test-Spelling` reports 0 issues.

## Refs

- Inventory rows (scratch, regenerable): `out/adrterm/rows.csv`, `out/adrterm/kind-area.txt`, `out/adrterm/identifiers.txt`, by
  `out/adrterm-inventory.ps1`.
- [drs-code-language](../../docs/drs/repository/drs-code-language.md),
  [controlled-vocabulary](../../docs/drs/repository/controlled-vocabulary.md), [plans](../../docs/drs/repository/plans.md).

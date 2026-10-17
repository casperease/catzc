---
task:
  id: "017"
  status: done
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: "nothing (Q38: P1 runs beside the module model; code phases wait)"
  targets:
    [
      docs/adr/automation,
      automation/Catzc.Base.Docs/configs/glossary.yml,
      automation/Catzc.Base.Docs/configs/adrs.yml,
      automation/Catzc.Base.Languages/configs/languages.yml,
      automation/Catzc.Base.QualityGates,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task017.md"
    folder: plans
    name: task017
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-ENGINE#4
      - ADR-DSGN-MODTYPE#1
      - ADR-DSGN-RUNMODE#1
      - ADR-REPO-VOCAB#8
---

# task017: layers P0 baseline and P1 doctrine

Decided (Q1 to Q11, all recommendations taken): automation stays the abstract term, a subject and cross-cutter; the PowerShell track is
named pwsh; ADR-AUTO-* codes are never re-coded; cats and catzc are ruled by ADR-CATS (task006) and are not glossary work here. P1 is docs
and glossary only, no path changes. Avoid-phrasings for the new meanings are added now; those retiring the old folder meaning wait for P6.
Stop when Test-Glossary, Test-AdrRegistry and Test-Terminology are clean on the touched files.

## Done (2026-10-17), with the corrections the tree forced and each check's verdict

- Steps 1 and 2: the P0 baseline and the hook edge fact are a section of plan-layers-vocabulary-rename-contracts. Test-GeneratedFiles and
  Test-Contracts pass; Test-Links had one `[Untracked]` and one bare citation in plans.yml, fixed; Test-WorldMap has two findings outside
  this plan (a yaml file in the `.claude` track, an undeclared `.vscode/` root). A failed hook rebuild keeps the published binary.
- Steps 3 and 4: `docs/adr/automation/layers.md` (ADR-AUTO-LAYERS, 7 rules) and `docs/adr/automation/importer.md` (ADR-AUTO-IMPORTER, 5
  rules). Corrections: rule 2 does not name an `executable` flag, which does not exist yet (Q-L1 is a LanguagesConfig change for P2);
  rule 5 cites no repository rule, because the citation graph forbids an automation ADR citing the repository domain, and the Context links
  the api-contracts ADR instead; IMPORTER#1 names no `.ps1` file, since the engine-neutrality gate forbids it in a rule summary. Both files
  are untracked, so their heads carry no imprint until the commit. Checks: `No links issues found.` and `No markdownlint issues found.`
  (`out/test-links/20261017-185212`, `out/test-markdownlint/20261017-185212`).
- Step 5: `adrs.yml` registers both; a `layer` key per automation ADR (language: UVPY, TYPES, GO, PY, BASH; engine: ENGINE; importer:
  CACHE, DEPM, BUNDLE, OVERLAY, ASSETDEP, IMPORTER; the rest default to automation), validated by `AdrsConfig` against the five layers with
  the default declared once, carried by `AdrRuleSet.Layer`; two tests. Checks: `[Invoke-TestFile] Passed (in-place)` AdrsConfig.Tests
  (`out/test-file/20261017-184635-03a85b`); `No adr-registry issues found.` (`out/test-adr-registry/20261017-184929`); the index lists both.
- Step 6: two dora-explains entries. Check: links clean in the run above.
- Step 7, corrected: glossary terms automation, command, implementation language, pwsh (Docs), importer (ModuleSystem), run mode (Docs,
  `**run mode**` bolded in ADR-DSGN-RUNMODE#1) and engine start environment (Engines) with reciprocal contrasts; `module` exists already
  (ADR-DSGN-MODTYPE#1) and `role` waits for task012, whose ADR owns it, since a rule of ADR-AUTO-LAYERS bolding it would define a term the
  layers do not own; `layer` keeps ADR-REPO-VOCAB#8 as its home, because a second rule bolding it would be a G3 finding, and gains the forms
  contract, engine, importer and AUTO, the last because the code `ADR-AUTO-LAYERS` itself reads as a qualified use of the family. The
  retired forms and the avoid phrasings of the old meanings wait for P6 (68 pages). Checks: Test-Glossary 221 issues, all pre-existing G4
  and G6 in plan and other files, none on a touched file (`out/test-glossary/20261017-185303`); `No terminology issues found.`
  (`out/test-terminology/20261017-185251`).
- Step 8: tracks.md lines 65 and 227 reworded (the design domain may not cite ADR-PWSH-TYPES, so the stack is named in words); ADR-AUTO-ENGINE#4
  and the sections "The black-box contract" of four ADRs are "The engine start environment", with the two remaining mentions in
  Get-EngineContract's head and the Languages reference article; `languages.yml` `engines:` is `formatters:` with LanguagesConfig
  (`formatters` property, messages), Format-Code, Invoke-RootConfigGenerator, their tests and their comment pages. Checks: `Passed`
  LanguagesConfig.Tests, New-VSCodeExtensions.Tests, Get-FormatEngineStamp.Tests, Format-Code.Tests (`out/test-file/20261017-18463*`);
  Build-RootConfig.Tests has eight failures, the four fixture-head ones plan-fast-push-followups owns and four "not a git checkout" ones
  from a peer's in-progress Get-RepoStatus change dirty in the tree, none from this rename; `No comments issues found.`
  (`out/test-comments/20261017-184638`, `-184928`, `-185248`).
- Step 9: `adr-checks.yml` `pwsh-cmdlet` token gains the pipeline and item cmdlets, `common-parameter` the engine's common parameters
  (`-Force` and `-PassThru` are catzc commands' own parameters and stay allowed). Check: `No adr-engine-neutrality issues found.`
  (`out/test-adr-engine-neutrality/20261017-184927`).
- Step 10: the plan's superseded steps and P0 and P1 ticked, two open steps added for P6's retirements and Q-L1's flag.

## Steps, as planned

1. P0 baseline, background scripts under out/, one gate each with the timeout prefix: Test-GeneratedFiles, Test-Links, Test-Contracts,
   Test-WorldMap. Record pass or fail lines in the plan under "P0 baseline (date)". Known unrelated reds stay listed (Test-Spelling 5,
   Test-Glossary G4, Test-Formatting on .compiled json, about 37 Test-ScriptAnalyzer). Check: four verdict lines in the plan.
2. P0 edge fact on a copy: read `Build-BashTimeoutHook` and `Invoke-AgentHookJanitor`; state whether a failed hook rebuild deletes the
   existing Assert-BashTimeout binary (a Bash call is unavailable if the hook breaks). Record in the plan. Check: the sentence exists.
3. `docs/adr/automation/layers.md`, new, ADR-AUTO-LAYERS: the layer model (automation the subject, language, engine, importer); the track is
   named by its stack (pwsh beside go, python, bash); automation is never a folder name in prose after the flip; `concern: automation` and
   the value-chain row AUTO keep their names. Rules bolded, present tense. Check: Test-Markdownlint, Test-Links.
4. `docs/adr/automation/importer.md`, new, ADR-AUTO-IMPORTER: the importer decides the mix (which languages and engines load, from
   `ImporterConfig`), throws NotImplemented for a configured language beyond pwsh, bash, python, go (Q11). Check: same gates.
5. `adrs.yml`: register both in the automation domain (`layers: { external: ADR-AUTO-LAYERS }`, `importer: { external: ADR-AUTO-IMPORTER }`)
   and add the `layer:` key the layer model asks for, with its default declared once on AdrsConfig. `Build-AdrIndex`. Check: AdrsConfig
   tests; Test-AdrRegistry clean; the index lists both.
6. `docs/adr/automation/dora-explains.md`: one entry each. Check: Test-Links.
7. `glossary.yml`: automation, importer, command, bare engine, language, module, role, run mode, layer, pwsh, defined by the new rules (role
   by the file-meta rule once task012 lands; until then its `defined_by` points at ADR-AUTO-LAYERS and task012 re-points it). Reciprocal
   contrasts; avoid-phrasings for the new meanings only. `Build-Glossary`. Check: Test-Glossary clean.
8. The four term collisions: `tracks.md:209` and `tracks.md:57` (reword against the new terms), `ADR-AUTO-ENGINE#4` ("black-box contract"
   becomes "engine start environment"; contract keeps the contracts/ meaning), `languages.yml` top-level `engines:` renamed `formatters:`
   with `LanguagesConfig.cs` and its tests (fresh pwsh). One file per step. Check: LanguagesConfig tests; Test-Terminology on tracks.md and
   the engine ADR.
9. `Test-AdrEngineNeutrality`: AUTO-layer ADRs carry no pwsh syntax; extend its rule set and tests. Check: the gate passes on
   docs/adr/automation.
10. `plan-layers-vocabulary-rename-contracts.md`: the scratchpad-copy and paste steps are superseded by the task files (Done, and why); tick
    P1 with the three gate verdicts. Check: grep `- [ ]` counts the P2 to P8 steps only.

## Report

As report-fixed.

---
task:
  id: "017"
  status: open
  plans: [plan-layers-vocabulary-rename-contracts]
  value: high
  blocked_on: nothing (Q38: P1 runs beside the module model; code phases wait)
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
    with_body_sha: "7619f20db331"
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
---

# task017: layers P0 baseline and P1 doctrine

Decided (Q1 to Q11, all recommendations taken): automation stays the abstract term, a subject and cross-cutter; the PowerShell track is
named pwsh; ADR-AUTO-* codes are never re-coded; cats and catzc are ruled by ADR-CATS (task006) and are not glossary work here. P1 is docs
and glossary only, no path changes. Avoid-phrasings for the new meanings are added now; those retiring the old folder meaning wait for P6.
Stop when Test-Glossary, Test-AdrRegistry and Test-Terminology are clean on the touched files.

## Steps

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

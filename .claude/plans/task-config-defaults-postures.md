---
task:
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: nothing; task-config-defaults-fragment is done
  targets:
    [
      automation,
      automation/.scriptanalyzer,
      docs/adr/automation/sensible-defaults.md,
      docs/adr/automation/consumer-overlay.md,
      docs/adr/configuration/module-config-loading.md,
      docs/adr/repository/api-contracts.md,
      docs/adr/automation/fail-fast-with-asserts.md,
    ]
---

# Task: config defaults Phases 4 and 5, every typed config and the ADRs

Decided (F5, Q101, S5): every config type is audited into a posture; every `-Default` literal in a getter goes; D22 (2026-10-18) replaces
the defaults contract: the shipped config file shows the defaults its type programs, and Test-ShippedConfigs keeps the two agreeing; an
analyzer rule flags a literal default in a function (ADR-PRIN-CONFIG#3 is its rule; the audit script is its seed). Q21: the assert ladder
(construct-time, load-time, cross-config, contract-time, repo-time) is a section in ADR-AUTO-FAILFAST. One config per change; the user runs
the full gate.

## Steps

1. [x] `out/audit-config-defaults.ps1`: for every registered config type, construct from `{}`; record whether it constructs, which
       properties are null, which getters pass `-Default`. Check: one row per registered type. Done 2026-10-18
       (`out/audit-config-defaults.md`): 63 types, 23 construct from `{}`, 40 throw naming the required key, one null property (go's `root`,
       resolved on demand from the repository by `GoConfig.ResolveRoot`, a computed default), and no function passes `-Default` any more.
2. [x] Triage into the three postures. Done 2026-10-18: the 40 that throw on `{}` are the required posture, registries whose data has no
       sensible default (adrs, globs, tools, the vscode files and the rest), each message naming the key; the 23 that construct are
       defaulted or empty-is-valid (adr-checks, comments, contracts, file-carriers, file-kinds, file-meta, folder-walk, go, links, maps,
       slides, test-policy, timeouts and the rest). Every row has its posture; the table in out/ is the worklist.
3. [x] One type per step. Done 2026-10-18 with nothing to convert: no type lacks a posture and no getter passes a literal; the one
       difference between a shipped file and its type (variants `have_customers: all`) carries its reason under `differs` (D22).
4. [x] `automation/.scriptanalyzer/NoLiteralDefault.psm1`: a `-Default` parameter, or a literal fallback after `??` or in
       `if (-not $v) { $v = 'x' }` on a value read from Get-Config, inside a module function, is a finding citing ADR-AUTO-DEFAULT#6 and
       ADR-PRIN-CONFIG#3. Narrowed from the draft: a placeholder for absent data that no config holds (`$probe.Version ?? 'none'`) is not
       one. Registered in CatzcRules.psm1 (which PSScriptAnalyzerSettings.psd1 already loads) and analyzer-adr-map.yml. Check: its tests
       pass; on the tree it finds nothing over 753 function files; Test-ScriptAnalyzer, Test-AnalyzerAdrMap and Test-Comments clean.
5. [x] `sensible-defaults.md` rule 6 bolds **posture**: defaulted, empty-is-valid or required, and no literal fallback in a function. Check:
       `ADRREG issues=0`, `LINKS issues=0`.
6. [x] `consumer-overlay.md` rules 1 and 8: the folder has one name, `.catzc/` (ADR-CATS#5), every bundle loaded against a root reads it as
       that root's overlay and must carry the module that applies it, and source mode reads only its config fragments. Check: same gates
       clean.
7. [x] `module-config-loading.md`: closed with no edit. A config with no shipped file is not a shape the repository keeps: D22 has every
       shipped file show its type's defaults, and Test-ShippedConfigs fails a registry entry that names no shipped file, so the rule that
       every shipped config has a type stays as it is.
8. [x] `fail-fast-with-asserts.md` gains "The assert ladder": construct-time, load-time, cross-config, contract-time and repo-time, each
       with where it is enforced, linked from rule 2. Check: Test-Markdownlint, Test-Links, Test-Spelling clean.
9. [x] Glossary: `posture` (ADR-AUTO-DEFAULT#6) and `config fragment` (ADR-AUTO-OVERLAY#4, now bolded there) in a new source,
       `Catzc.Base.Config/configs/glossary.yml`; Build-Glossary. Check: Test-Glossary has no finding on them (its one finding is
       `Get-AdoGraphContext.ps1:19`, another session's file).
10. [x] No citation moved, so Update-AdrCitation has nothing to rewrite; Build-AdrIndex and Build-Glossary regenerated; Test-Links clean on
        the touched pages.
11. [x] `plan-config-defaults.md`: Phases 4 and 5 ticked; the plan is deleted in task-closing-sweep. Check: grep `- [ ]` counts zero.

## Report

As report-fixed.

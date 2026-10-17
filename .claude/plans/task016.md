---
task:
  id: "016"
  status: open
  plans: [plan-config-defaults]
  value: high
  blocked_on: task015
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
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task016.md"
    folder: plans
    name: task016
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
      - ADR-AUTO-DEFAULT#6
      - ADR-CATS#5
      - ADR-PRIN-CONFIG#3
---

# task016: config defaults Phases 4 and 5, every typed config and the ADRs

Decided (F5, Q101, S5): every config type is audited into a posture; every `-Default` literal in a getter goes; the contract folder gains
one defaults file per overridable type; an analyzer rule flags a literal default in a function (ADR-PRIN-CONFIG#3 is its rule; the audit
script is its seed). Q21: the assert ladder (construct-time, load-time, cross-config, contract-time, repo-time) is a section in
ADR-AUTO-FAILFAST. One config per change; the user runs the full gate.

## Steps

1. `out/audit-config-defaults.ps1`: for every registered config type, construct from `{}`; record whether it constructs, which properties
   are null, which getters pass `-Default`. Output a table to `out/audit-config-defaults.md`. Check: one row per registered type.
2. Triage the table into the three postures in `plan-config-defaults.md` under "Rollout worklist", one line per type with its posture and
   its getters. Check: every row has a posture.
3. One type per step, in worklist order: constants on the type, construction throws for required keys, getters lose literals, tests updated
   (fresh pwsh per C# edit). Sealed configs take defaults and no fragment and get no contract. Overridable types get their generated
   defaults contract (Build-ConfigDefaultsContract from task015). Check: that config's tests; Test-Contracts after each contracted type.
4. `automation/.scriptanalyzer/NoLiteralDefault.psm1`, new rule: a `-Default` parameter or a literal fallback (`?? 'x'`,
   `if (-not $v) { $v = 'x' }`) inside a public getter that reads a registered config is a finding citing ADR-PRIN-CONFIG#3 and
   ADR-AUTO-DEFAULT#6; tests with fixtures; registered in `PSScriptAnalyzerSettings.psd1`. Check: its tests pass; Test-ScriptAnalyzer clean
   on the converted modules.
5. `docs/adr/automation/sensible-defaults.md` rule 6: posture per property, defaults as constants on the type, contracted defaults published
   from the type. Present tense. Check: Test-AdrRegistry, Test-Links.
6. `docs/adr/automation/consumer-overlay.md` rules 1 and 8: the repository's own fragments under `.catzc/<track>/` in source mode; no alias
   (cite ADR-CATS#5). Check: same gates.
7. `docs/adr/repository/api-contracts.md` rule 6: the `defaults` asset kind. `docs/adr/configuration/module-config-loading.md`: a typed
   config without a shipped file. Check: same gates.
8. `docs/adr/automation/fail-fast-with-asserts.md`: an "Assert ladder" section naming the five levels and where each is enforced (type
   constructor, Get-Config, cross-config validators, Test-Contracts, repo gates). Check: Test-Markdownlint, Test-Links.
9. Glossary: `fragment`, `posture`, `contracted defaults`, defined by the rules above; Build-Glossary. Check: Test-Glossary clean.
10. `Update-AdrCitation` and the reference-page generators in the background; `Test-Links` on the touched pages. Check: clean.
11. `plan-config-defaults.md`: tick Phases 4 and 5; the plan is deleted in T036 once Test-Contracts is clean on every contracted type.
    Check: grep `- [ ]` counts zero.

## Report

As report-fixed.

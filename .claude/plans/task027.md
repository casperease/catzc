---
task:
  id: "027"
  status: open
  plans: [plan-adr-link-cleanup-prose-to-pages]
  value: medium
  blocked_on: task007 (body-sha Phase 0) and task008 step 4 (.unordered emptied); steps 1 to 3 can start now
  targets: [docs, automation/Catzc.Base.QualityGates, automation/Catzc.Base.Docs, out/adr-link-ledger.csv]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task027.md"
    folder: plans
    name: task027
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
      - ADR-REPO-HELP#3
---

# task027: the ADR link cleanup, Phase 1 applied and Phase 2 started

Decided (Q55 to Q60): .unordered rows leave the ledger; ADR-REPO-HELP#3 is relaxed so a citation inside a help sentence is allowed and only
a bare citation line is reported; the review is sample-then-stop and fixes patterns, not rows; thresholds are measured (Q60). Phase 2 D1: a
comment page stays lossless and an explanation article carries the shared why; D2 the head `config:` stays; D3 tests are out; D4 delete only
a clear restatement; D5 thresholds from the data, a setting with its default declared once. Built: Get-AdrUsage -GroupBy, the 5,203-row
ledger with stable keys, the pilot review of the pipelines slice (88 rows).

## Steps

1. [x] `docs/adr/repository/function-help.md` rule 3: a citation inside a help sentence is allowed; a bare citation line is the finding. Its
   gate (`Test-Help` or the help processor in QualityGates) reports only the bare line; its test gains one case each way. Check:
   Test-AdrRegistry, Test-Links clean; the gate's Pester file passes. Done 2026-10-17 by session catzc-6c: rule 3 reworded; the check,
   `Get-HelpHeadFinding` (private, QualityGates, run by the ps-help imprint step), already matched a whole line only, so its test gained the
   one case 'allows a citation inside a help sentence'; Test-AdrRegistry 0 (`out/test-adr-registry/20261017-203125`), Test-Links and
   Test-Markdownlint 0 on the ADR (`out/test-links/20261017-203125`, `out/test-markdownlint/20261017-203125`); Pester 33 passed.
2. [x] Q58 TryParse regression test in `Catzc.Base.Docs` tests (the AdrCodeForm or usage parser case that regressed). Check: the Pester file
   passes. Done 2026-10-17 by session catzc-6c (correction: the TryParse fix is in `Get-AdrCodesFileMetaFact`, QualityGates, not Docs): the
   case 'drops a rule number past int range instead of throwing' in `Get-AdrCodesFileMetaFact.Tests.ps1`; passes.
3. [x] Q59 the five gates on the usage code (Test-ScriptAnalyzer, Test-Formatting, Test-Spelling, Test-Links, Test-Comments on Get-AdrUsage,
   Get-AdrUsageRow, Group-AdrUsage), one background script each. Check: each clean. Done 2026-10-17 by session catzc-6c (correction: the
   three live in QualityGates): Test-ScriptAnalyzer 0 (`out/test-script-analyzer/20261017-203215`), Test-Spelling 0
   (`out/test-spelling/20261017-203217`), Test-Comments 0 (`out/test-comments/20261017-203217`), `Format-Code -DryRun` 0 changes in place
   of Test-Formatting, which takes no -Path; Test-Links had no page to check, since the three have no comment page.
4. Rebuild the ledger without .unordered rows: `out/build-adr-link-ledger.ps1` then `out/prepass-adr-link-ledger.ps1` in the background;
   keys are stable so verdicts survive. Check: about 4,900 rows; the pilot's 88 verdicts still attached.
5. F8: every rule statement in the principles ADRs becomes bold, one ADR per step (everything-as-code, configure-not-program,
   one-living-version, poka-yoke, reduce-variability, reduce-waste, plus cats-and-catzc from task006). Check: Test-Glossary finds every
   defining rule; Test-Markdownlint clean.
6. Step 1.3 apply, one slice per step, one file at a time with Edit: Format-Links, Format-FileMeta, Test-Links and Test-FileMeta on the
   file, the ledger row marked applied. First slice: the two narrow fixes at `docs/explanation/flow/no-gate-checks-rules-one-and-four.md`
   lines 62 and 63. Peer-dirty files skipped and named. Check: Test-Links clean per file; `out/apply-verdicts.ps1` marks the rows.
7. Step 1.4 verify after each slice: `Get-AdrUsage` before and after (rule links fall by widen and merge count, whole-ADR links rise by the
   same, no unregistered code); ledger has no row without a verdict or unapplied; Test-Glossary and Test-Spelling on changed files. After
   Phase 1: `Get-AdrCodesFileMetaFact` drops unregistered codes from held lists (the seven placeholder heads). Check: the counts in the
   plan.
8. Phase 2 per D1 to D5: Step 2.0 inventory (`out/measure-text-in-source.ps1` writes `out/source-text-ledger.csv`; the threshold setting
   with its default on the config type); 2.1 verdicts; 2.2 review in slices (every delete verdict read first); 2.3 apply one file at a time;
   2.4 verify. Check: Test-Comments, Test-FileMeta clean per file; the ledger complete.
9. The `tests-comments-rollout.ps1` tool candidate (from plan-out-artifacts) becomes a module function with tests if Phase 2 needs the
   before-and-after citation-map proof; else recorded as not needed. Check: the function's Pester file, or the line.
10. Tick the plan's steps; the carried draft goes when its data is in the tree; the plan is deleted in T036. Check: grep `- [ ]` counts
    zero.

## Report

As report-fixed, with the Get-AdrUsage counts before and after.

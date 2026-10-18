---
task:
  status: open
  plans: [plan-adr-link-cleanup-prose-to-pages]
  value: medium
  blocked_on: nothing; body-sha Phase 0 and the .unordered audit landed 2026-10-17
  targets: [docs, automation/Catzc.Base.QualityGates, automation/Catzc.Base.Docs, out/adr-link-ledger.csv]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/task-adr-link-cleanup.md"
    folder: plans
    name: task-adr-link-cleanup
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
      - ADR-PIPE-NAME#{1,4}
      - ADR-REPO-HELP#3
      - ADR-REPO-VOCAB#1
---

# Task: the ADR link cleanup, Phase 1 applied and Phase 2 started

Decided (Q55 to Q60): .unordered rows leave the ledger; ADR-REPO-HELP#3 is relaxed so a citation inside a help sentence is allowed and only
a bare citation line is reported; the review is sample-then-stop and fixes patterns, not rows; thresholds are measured (Q60). Phase 2 D1: a
comment page stays lossless and an explanation article carries the shared why; D2 the head `config:` stays; D3 tests are out; D4 delete only
a clear restatement; D5 thresholds from the data, a setting with its default declared once. Built: Get-AdrUsage -GroupBy, the 5,203-row
ledger with stable keys, the pilot review of the pipelines slice (88 rows).

## Steps

1. [x] `docs/adr/repository/function-help.md` rule 3: a citation inside a help sentence is allowed; a bare citation line is the finding. Its
       gate (`Test-Help` or the help processor in QualityGates) reports only the bare line; its test gains one case each way. Check:
       Test-AdrRegistry, Test-Links clean; the gate's Pester file passes. Done 2026-10-17 by session catzc-6c: rule 3 reworded; the check,
       `Get-HelpHeadFinding` (private, QualityGates, run by the ps-help imprint step), already matched a whole line only, so its test gained
       the one case 'allows a citation inside a help sentence'; Test-AdrRegistry 0 (`out/test-adr-registry/20261017-203125`), Test-Links and
       Test-Markdownlint 0 on the ADR (`out/test-links/20261017-203125`, `out/test-markdownlint/20261017-203125`); Pester 33 passed.
2. [x] Q58 TryParse regression test in `Catzc.Base.Docs` tests (the AdrCodeForm or usage parser case that regressed). Check: the Pester file
       passes. Done 2026-10-17 by session catzc-6c (correction: the TryParse fix is in `Get-AdrCodesFileMetaFact`, QualityGates, not Docs):
       the case 'drops a rule number past int range instead of throwing' in `Get-AdrCodesFileMetaFact.Tests.ps1`; passes.
3. [x] Q59 the five gates on the usage code (Test-ScriptAnalyzer, Test-Formatting, Test-Spelling, Test-Links, Test-Comments on Get-AdrUsage,
       Get-AdrUsageRow, Group-AdrUsage), one background script each. Check: each clean. Done 2026-10-17 by session catzc-6c (correction: the
       three live in QualityGates): Test-ScriptAnalyzer 0 (`out/test-script-analyzer/20261017-203215`), Test-Spelling 0
       (`out/test-spelling/20261017-203217`), Test-Comments 0 (`out/test-comments/20261017-203217`), `Format-Code -DryRun` 0 changes in
       place of Test-Formatting, which takes no -Path; Test-Links had no page to check, since the three have no comment page.
4. [x] Rebuild the ledger without .unordered rows: `out/build-adr-link-ledger.ps1` then `out/prepass-adr-link-ledger.ps1` in the background;
       keys are stable so verdicts survive. Check: about 4,900 rows; the pilot's 88 verdicts still attached. Done 2026-10-18: 6,449 rows, no
       `.unordered` row. Correction from the tree: a first rebuild gave 32,247 rows because the generated minimap sister pages under
       `docs/explanation/.assets` joined the tree after the ledger was built; the builder skips the three `.assets` trees as it skipped
       `docs/.assets` (458 files), and the glossary and index pages stay in as generated rows. The pilot's 97 pipelines verdicts re-attached
       through `out/apply-verdicts.ps1` (the 6 `.unordered` keys are gone with their files); the 7 `hold` rows on head-text citations became
       `keep`, since ADR-REPO-HELP#3 allows a citation inside a help sentence (step 1): 95 keep, 2 narrow. Pre-pass: 3,465 read, 1,719
       check, 925 confirm, 340 skip.
5. [x] F8: every rule statement in the principles ADRs becomes bold, one ADR per step (everything-as-code, configure-not-program,
       one-living-version, poka-yoke, reduce-variability, reduce-waste, plus cats-and-catzc). Check: Test-Glossary finds every defining
       rule; Test-Markdownlint clean. Corrected 2026-10-18 from the tree: no domain bolds whole rule statements (0 of 1,064 rules); the
       uniform form is the defined term bolded inside the rule's normative summary, which `Get-GlossaryAnchorViolations` reads
       (ADR-REPO-VOCAB#1 and its enforcement section), and the principles ADRs already bold every term they define (cats-and-catzc: catzc,
       cats). Bolding whole statements would make the principles the one odd domain and anchor nothing, so no rule changes;
       `GLOSSARY issues=0` on 2026-10-18 is the check that every defining rule is found. If the literal reading of Q121 (a) was meant, that
       is a question for the user.
6. [x] First slice of step 1.3 apply, one slice per step, one file at a time with Edit: Format-Links, Format-FileMeta, Test-Links and
       Test-FileMeta on the file, the ledger row marked applied. First slice: the two narrow fixes at
       `docs/explanation/flow/no-gate-checks-rules-one-and-four.md` lines 62 and 63. Peer-dirty files skipped and named. Check: Test-Links
       clean per file; `out/apply-verdicts.ps1` marks the rows. Done 2026-10-18 for the first slice: the page's lines 65 and 66 say
       `ADR-PIPE-NAME#1, #2, #3, #4 and #6` and `ADR-PIPE-NAME#4`; Format-Links aligned, Format-FileMeta followed, `LINKS issues=0`,
       `FILEMETA issues=0`, `GLOSSARY issues=0`, `SPELL issues=0` (`out/test-links/20261018-111351`); the two ledger rows carry
       `Applied: 2026-10-18`, a column the ledger gains here. The remaining slices, about 6,100 editable rows under the sample-then-stop
       review, stay open.
7. [x] Step 1.4 verify after the first slice: `Get-AdrUsage` before and after (rule links fall by widen and merge count, whole-ADR links
       rise by the same, no unregistered code); ledger has no row without a verdict or unapplied; Test-Glossary and Test-Spelling on changed
       files. After Phase 1: `Get-AdrCodesFileMetaFact` drops unregistered codes from held lists (the seven placeholder heads). Check: the
       counts in the plan. Done 2026-10-18 for the first slice: `Get-AdrUsage` 7,473 rows before and 7,474 after (5,657 rule, 1,817 whole;
       head 5,190, link 2,284), the one new row the page head's rule citation that the narrow produced; unregistered codes 0 before and
       after. The `Get-AdrCodesFileMetaFact` change is in a file session catzc-e5 holds, so it waits for that session.
8. Phase 2 per D1 to D5: Step 2.0 inventory (`out/measure-text-in-source.ps1` writes `out/source-text-ledger.csv`; the threshold setting
   with its default on the config type); 2.1 verdicts; 2.2 review in slices (every delete verdict read first); 2.3 apply one file at a time;
   2.4 verify. Check: Test-Comments, Test-FileMeta clean per file; the ledger complete.
9. The `tests-comments-rollout.ps1` tool candidate (from plan-out-artifacts) becomes a module function with tests if Phase 2 needs the
   before-and-after citation-map proof; else recorded as not needed. Check: the function's Pester file, or the line.
10. Tick the plan's steps; the carried draft goes when its data is in the tree; the plan is deleted in task-closing-sweep. Check: grep
    `- [ ]` counts zero.

## Report

As report-fixed, with the Get-AdrUsage counts before and after.

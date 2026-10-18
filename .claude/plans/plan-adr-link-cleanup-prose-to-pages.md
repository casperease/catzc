---
plan:
  status: blocked
  value: medium
  reviewed: 2026-10-16
  blocked_on: the plan move of plan-plans-body-sha-landing-zone; three ledger recommendations await an answer
  targets: [docs, automation/Catzc.Base.QualityGates, out/adr-link-ledger.csv]
---

# Every edge to an ADR says exactly what it means; then source prose moves into sister pages

Phase 1 reads every declared edge to an ADR and narrows, widens or retargets it. Phase 2 moves larger text out of source files into their
comment pages and explanation articles, leaving one-liners and algorithmic insight. Phase 1 is done; Phase 2 is applied apart from two held
files.

## Why its value is medium

Hygiene with a long tail: 5,203 ledger rows, one pilot slice reviewed (88 rows). The value grows in Phase 2, where source files get
readable. It cannot move until the plans plan removes the 274 .unordered rows and the body-hash drift on every ADR edit.

## Needed docs

- Decision on ADR-REPO-HELP#3: relax it (687 head-text citations) rather than strip them.
- Phase 2 destination is decided (D1): comment pages stay lossless, explanation articles carry the why.
- The two narrow edits in docs/explanation/flow/no-gate-checks-rules-one-and-four.md, applied through the tool, never by hand.

## Needed tests

- Regression test for the TryParse fix in Get-AdrCodesFileMetaFact on an oversized rule number (missing).
- Formatting, link, spelling, glossary and analyzer gates on Get-AdrUsage, Get-AdrUsageRow, Group-AdrUsage (14 tests pass; gates not run).
- Test-Links clean after each applied slice.

## Open steps

- Decided 2026-10-16 (Q55 to Q57): .unordered rows are excluded from the ledger (274 rows; those plans are deleted anyway); ADR-REPO-HELP#3
  is relaxed so a citation inside a help sentence is allowed and only a bare citation line is reported (the sentence is where the why lives;
  the head stays the derived complete set; 0 edits); the review is sample-then-stop.
- [x] Amend ADR-REPO-HELP#3 and its gate accordingly (check: Test-Links, Test-AdrRegistry clean; the gate still reports a bare line). Done
      2026-10-17 (task-adr-link-cleanup step 1, session catzc-6c): the gate already matched a whole line; one test case added; verdicts in
      task-adr-link-cleanup.
- [x] Q58 TryParse regression test; Q59 the five gates on the usage code (check: the test passes; the gates clean). Done 2026-10-17
      (task-adr-link-cleanup steps 2 and 3, session catzc-6c): the test is in Get-AdrCodesFileMetaFact.Tests.ps1, the gates are clean;
      verdicts in task-adr-link-cleanup.
- [x] F8: every rule statement in the principles ADRs becomes bold, uniform with the other domains (check: Test-Glossary finds every
      defining rule); the sampled review fixes patterns, not rows (Q57, Q60 measured thresholds). 2026-10-18 (task-adr-link-cleanup step 5):
      the uniform form is the defined term bolded in the normative summary, which the principles already follow; no domain bolds whole
      statements; `GLOSSARY issues=0`.
- [x] Rebuild the ledger without .unordered rows (check: row count about 4,900). Done 2026-10-18: 6,449 rows after the builder skips the
      generated diagram text of all three `.assets` trees; the pilot's 97 verdicts re-attached (95 keep, 2 narrow).
- [x] Add the TryParse regression test (check: its Pester file). Done 2026-10-17, the same step as Q58 above.
- [x] Run the five gates on the usage code (check: each clean). Done 2026-10-17, the same step as Q59 above.
- [x] Step 1.3 apply and 1.4 verify, one slice at a time (check: Test-Links clean). First slice done 2026-10-18: the two narrow fixes in
      `docs/explanation/flow/no-gate-checks-rules-one-and-four.md`, `LINKS issues=0`; usage 7,473 to 7,474 rows, no unregistered code.
      Slices 2 and 3 done 2026-10-18: the rule-number pattern (two pages narrowed), the retarget signal (0 of 78, closed), the merge signal
      (2 duplicates dropped, 118 keep); 312 of 6,449 ledger rows reviewed. The samples, 2026-10-18 (seed 20261018): 100 whole links, 0
      narrows; 150 rule links, 0 widens. Sample-then-stop (Q57) closes the review: the 4,963 unread rows keep their citations, and every
      editable row of the 6,449 carries a verdict. Phase 1 is done: the `Get-AdrCodesFileMetaFact` placeholder fix is moot since 2026-10-18,
      when the file-meta pass removed the held-codes merge, so a head's codes come from the text and the comment page only
      (ADR-REPO-FILEMETA#14) and no head can hold an unregistered code.
- [x] Phase 2 per decided D1, one file at a time (check: Test-Comments, Test-FileMeta clean). 2026-10-18 (task-adr-link-cleanup step 8): the
      inventory, `out/inventory-source-text.ps1`, finds 6,099 pieces of text in 1,173 source files; every piece has a verdict, 6,082 stay, 2
      hold (files in use), 15 decided by D23 (2026-10-18, delegated to the domain rules) and applied: `.claude/slides` and
      `.github/workflows` joined the comment page map and their 8 runs moved to pages, the `.claude/drawio` runs stay, and the ADR index's
      text moved from Build-AdrIndex into `configs/adr-index.yml` (verdicts in task-adr-link-cleanup step 8). The threshold is 3 lines or
      200 characters (D5), a `CommentsConfig` setting once a function reads it. The 2 held files closed the same day: nothing left to move
      in either.

## Done, and why (session report of 2026-10-16 15:23)

- Get-AdrUsage takes -GroupBy Rule or Document; Get-AdrUsageRow and Group-AdrUsage ship with their tests, 14 pass, Test-FileMeta clean for
  these files. Built so the ledger and the analysis read one measured source.
- The edge ledger out/adr-link-ledger.csv: 5,203 rows, each with a stable Key, the exact line, a paragraph or list-item context, the rule's
  summary and the pre-pass triage. Keyed so verdicts survive a rebuild.
- Pilot review of the pipelines slice: 88 rows, 79 keep, 2 narrow, 7 hold. Analysis and recommendations in out/analysis-adr-link-ledger.txt.
- The plans plan (now plan-plans-body-sha-landing-zone) written with the user's answers recorded.
- Not done, stated by that session: no document edited; the two narrow fixes are lines 62 and 63 of
  docs/explanation/flow/no-gate-checks-rules-one-and-four.md; the earlier Test-Formatting failure came from files another session was
  editing and was not re-run; the remaining about 4,800 ledger rows (rest of Step 1.2, all of 1.3 and 1.4) wait on the three decisions.
- The two draft plans were not trimmed to the new plan rules (short, present tense, no history); that is the cleaner's job and the cleaner
  does not exist yet. Decisions and plan locations saved to memory as adr-link-and-plan-program.md.

## Refs

- the Phase 2 half of the draft is carried below (formerly out/plan-adr-link-cleanup.md); its Phase 1 half is done and gone (git keeps it);
  the work runs from task-adr-link-cleanup
- out/build-adr-link-ledger.ps1, out/prepass-adr-link-ledger.ps1, out/refresh-ledger.ps1, out/apply-verdicts.ps1
- out/analysis-adr-link-ledger.txt
- docs/adr/repository/markdown-links.md

## Carried: the Phase 2 half of out/plan-adr-link-cleanup.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

## Phase 2: larger text out of source files into sister pages

Goal: in every `yml`, `yaml`, `cs`, `ps1` and `psm1` source file, keep only what the code does not say itself: a unique one-line insight or
an algorithmic insight. Everything larger lives in the file's sister Markdown page, sorted into **reference** (what it is and does) and
**explanation** (why it is that way), one living copy ([ADR-PRIN-ONELIVE](../../docs/adr/principles/one-living-version.md)).

## What already exists, and what is left

Most of the mechanism and most of the move are done. `Export-Comments` (run by `Format-Code`) moves every comment of two or more lines out
of PowerShell, YAML, pipeline YAML, C# and Bicep files into `docs/references/<path>/<file>.md` as `## comment:N` sections, losslessly
(`Build-CommentView` puts them back, `Test-Comments` gates it). 1,076 comment pages exist beside 158 explanation pages.

Measured on 2026-10-16 with `out/measure-text-in-source.ps1` (tracked files; vendor, `assets/`, tests and fixtures counted apart):

| Where                       | Files | Multi-line comment runs | Single-line comments | Head `config:` lines |
| --------------------------- | ----: | ----------------------: | -------------------: | -------------------: |
| source `ps1`                |   719 |            6 (17 lines) |                  602 |               14,572 |
| source `psm1`               |    27 |                       0 |                   80 |                    - |
| source `cs`                 |   261 |                       0 |                1,091 |             not read |
| source `yml` and `yaml`     |   102 |           18 (71 lines) |                  150 |                    - |
| tests `ps1`                 |   787 |             1 (2 lines) |                  586 |                    - |
| `assets/` (copied verbatim) |    51 |          79 (545 lines) |                   61 |                    - |
| vendor (third party)        |     6 |       351 (2,013 lines) |                  546 |                    - |

What the numbers say:

- **The comment text has mostly left.** About 88 lines of multi-line comments remain in source files, plus the 2 comments `Format-Code`
  reported as pending. Finishing them is a run of the existing tool.
- **The bulk of the remaining prose is the head `config:` of the PowerShell files: 14,572 lines across 719 files**, about 20 per file, up to
  109 in one. That is the `synopsis`, `description`, `parameters`, `outputs` and `examples`, which
  [ADR-REPO-HELP#1](../../docs/adr/repository/function-help.md#rule-adr-repo-help1) makes the function's help itself: structured data a tool
  parses, with no comment-based help block anywhere. It is the largest block of prose left in source files, and it is sanctioned there
  (decision D2 below).
- **About 1,900 single-line comments remain in source.** Each is a candidate for one of three verdicts: stays as insight, deleted because it
  restates the code, or moved because it is long or explains design.
- **Not yet measured:** long string literals and here-strings (throw messages, templates), long values in YAML data (`description:` keys and
  similar), and C# heads and `///` documentation, where my reader found no head. Step 2.0 measures them.
- **Folders outside the page map.** The ledger run found multi-line comments with ADR citations in `.github/workflows/*.yml` and
  `.claude/drawio/` scripts. `comments.yml` maps pages only for `automation/`, `pipelines/`, `infrastructure/` and `.claude/hooks/`, so the
  exporter never moved those comments. Step 2.0 measures them and adds the folders to the `pages` map if the count warrants it.
- `assets/` and vendor stay as they are: an asset is copied verbatim elsewhere, and vendor code is third-party.

## The rule to settle first

[ADR-REPO-COMMENTS#2](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments2) says a moved comment is a section of the page
that holds its lines exactly and that the view puts back unchanged, and
[#3](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments3) puts every page under `docs/references/`. Sorting text into
`docs/explanation/` therefore cannot be done by lifting a section out of a page, because the round-trip would no longer reproduce the file.
Two ways to reconcile (decision D1):

- **(a) Keep the page lossless; write the explanation beside it.** The comment page stays the sister page and keeps its sections. A new
  `docs/explanation/<area>/<topic>.md` article carries the _why_ that several pages share, and the page's section links to it. No rule
  changes. The text exists twice only where the page holds the verbatim comment and the article holds the synthesis, which is a second copy
  of some words. This is the cheapest and keeps `Test-Comments` as is.
- **(b) Let a section be promoted.** Amend COMMENTS#2/#3 so a section may be marked `promoted: <article>`, the view reads its text from the
  article, and `Test-Comments` follows the pointer. One living copy, but it changes a rule, the view builder and the gate in one change.

Decided: (a). (b) is revisited only if the duplication proves a real burden.

## Steps, part two

### Step 2.0: inventory every piece of larger text

An `out/` script writes `out/source-text-ledger.csv`, one row per piece, for all five languages:
`file, kind, line, lines, chars, text, verdict, destination, note`. Kinds: `comment-run`, `string-literal`, `data-value`,
`single-line-comment`, `xml-doc`. The head `config:` is not inventoried (D2) and tests are not scanned (D3). The script first reports the
size distribution of string literals and data values so the threshold can be chosen from it (D5); thresholds (lines and characters) are
settings with a default, not constants in the script.

### Step 2.1: verdicts

| Verdict         | When                                                                                                                       | Result                                                            |
| --------------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- |
| **stay**        | One line of insight the code does not state: an invariant, an order it depends on, an edge it guards, why a branch exists. | none                                                              |
| **delete**      | A clear restatement of the next line of code (D4); a near-duplicate stays.                                                 | removed; the page keeps no copy, because there is nothing to keep |
| **reference**   | What a thing is or does: interface, config keys, formats, behaviours, examples.                                            | the page, as a section                                            |
| **explanation** | Why it is this way: trade-offs, rationale, how parts fit; present tense, plain language.                                   | an explanation article, linked from the page (D1 a)               |
| **rule**        | The text states a rule that belongs in an ADR.                                                                             | flagged to you; nothing moves                                     |

Algorithmic insight (why this order, why this bound, what the loop keeps true) stays in the file as one line and is never moved, even if it
is long to say; if it needs more than a line it moves and the line points nowhere (nothing in the file, ADR-REPO-COMMENTS#1).

### Step 2.2: review in slices

One slice per module under `automation/` (and `pipelines/`, `infrastructure/`, `.claude/hooks/`), so a reviewer reads one module's prose
together. Reviewers fill the verdict, destination and a one-line note in the ledger and edit nothing. Delegation uses `catzc-worker`, one
slice per brief, none launched until you ask. You read **5%** of the verdicts per slice first.

### Step 2.3: apply, one file at a time

1. Let `Export-Comments` move comment runs (it already does the work for these).
2. Write the explanation article for the slice, then the links from the page sections.
3. Edit the file for `delete` and long `reference` verdicts, with the Edit tool.
4. Per file: `Format-Code` (comments step), `Test-Comments` and the view round-trip, `Format-FileMeta`, `Test-Links`, `Test-Glossary`,
   `Test-Spelling`.

### Step 2.4: verify

Re-run the measurement. Targets: multi-line comment runs in source files at zero; single-line comments each reviewed; every ledger row
applied; `Test-Comments` and `Test-FileMeta` clean. The head `config:` line count is unchanged by design (D2).

## Phase 2 out of scope

- `assets/` (copied verbatim), vendor code, generated files, fixtures, contracts.
- ADR bodies and their wording.
- Test files and test titles (D3); the test rules govern the titles.
- The head `config:` of PowerShell files, which is the function's help (D2).
- Source code itself: no behaviour changes, only text.

## Decisions (Phase 2)

Decided on 2026-10-16:

1. **D1, destination:** option (a). A comment page stays lossless, and an explanation article in `docs/explanation/` carries the _why_ that
   several sections share, linked from the page's sections. COMMENTS#2/#3 are not amended. Option (b), promoting a section to an article, is
   revisited only if the duplicated words prove a real burden.
2. **D2, head `config:` of the 719 PowerShell files (14,572 lines):** stays in place. The head is the function's help by rule
   ([ADR-REPO-HELP#1](../../docs/adr/repository/function-help.md#rule-adr-repo-help1)); moving a description out would amend HELP#1/#2 and
   needs a page section with no code line, which COMMENTS#2 has no form for. Only outliers of several dozen lines get a hand review later.
3. **D3, tests:** out of this pass. They hold one multi-line comment and 586 single-line ones.
4. **D4, deleting one-liners:** delete only a clear restatement of the next line of code. Everything else stays, and near-duplicates are
   left alone. Every `delete` verdict is in your 5% read first, since a deletion is recoverable only through git.
5. **D5, thresholds:** set from the data. Step 2.0 measures the size distribution of string literals and data values, then the cutoff is
   chosen. The starting guess is 3 lines or 200 characters, and the value is a setting with its default declared once on the config type
   ([ADR-AUTO-DEFAULT#6](../../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)), not a constant in a script.

## Effort

Phase 1 reads about 670 markdown rule links in slices of 100–150 edges; its cost is the per-file edits and checks. Phase 2 is smaller in
comments (almost done), so its cost is the verdict pass over about 1,900 single-line comments and the string literals and data values that
Step 2.0 finds. The inventory's output decides the slice sizes.

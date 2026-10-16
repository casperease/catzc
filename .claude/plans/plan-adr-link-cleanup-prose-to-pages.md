---
plan:
  status: blocked
  value: medium
  reviewed: 2026-10-16
  blocked_on: plan-plans-body-sha-landing-zone phase 0 and the plan move; three ledger recommendations await an answer
  targets: [docs, automation/Catzc.Base.QualityGates, out/adr-link-ledger.csv]
---

# Every edge to an ADR says exactly what it means; then source prose moves into sister pages

Phase 1 reads every declared edge to an ADR and narrows, widens or retargets it. Phase 2 moves larger text out of source files into their
comment pages and explanation articles, leaving one-liners and algorithmic insight. Phase 1 is paused; Phase 2 has not started.

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

- Decided 2026-10-16 (Q55 to Q57): .unordered rows are excluded from the ledger (274 rows; those plans are deleted anyway);
  ADR-REPO-HELP#3 is relaxed so a citation inside a help sentence is allowed and only a bare citation line is reported (the sentence is
  where the why lives; the head stays the derived complete set; 0 edits); the review is sample-then-stop.
- [ ] Amend ADR-REPO-HELP#3 and its gate accordingly (check: Test-Links, Test-AdrRegistry clean; the gate still reports a bare line).
- [ ] Q58 TryParse regression test; Q59 the five gates on the usage code (check: the test passes; the gates clean).
- [ ] F8: every rule statement in the principles ADRs becomes bold, uniform with the other domains (check: Test-Glossary finds every
  defining rule); the sampled review fixes patterns, not rows (Q57, Q60 measured thresholds).
- [ ] Rebuild the ledger without .unordered rows (check: row count about 4,900).
- [ ] Add the TryParse regression test (check: its Pester file).
- [ ] Run the five gates on the usage code (check: each clean).
- [ ] Step 1.3 apply and 1.4 verify, one slice at a time (check: Test-Links clean).
- [ ] Phase 2 per decided D1, one file at a time (check: Test-Comments, Test-FileMeta clean).

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
- Paste-after-clear line from that session, re-pointed: read .claude/CLAUDE.md and docs/adr/index.md, then
  prompt-adr-links-and-plans-continue.md beside this file, and follow it.

## Refs

- the full draft is carried below (formerly out/plan-adr-link-cleanup.md; status at its top); the shared continuation prompt is
  prompt-adr-links-and-plans-continue.md beside this file
- out/build-adr-link-ledger.ps1, out/prepass-adr-link-ledger.ps1, out/refresh-ledger.ps1, out/apply-verdicts.ps1
- out/analysis-adr-link-ledger.txt
- docs/adr/repository/markdown-links.md

## Carried: out/plan-adr-link-cleanup.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: ADR link cleanup (Phase 1), then source-file prose into sister pages (Phase 2)

Two phases, in this order. Phase 1 makes every edge to an ADR say exactly what it means. Phase 2 moves the larger text out of source files
into their sister Markdown pages and leaves only unique one-liners and algorithmic insight. Phase 1 goes first because prose carries ADR
links: the text Phase 2 moves is then already correct, and no link is fixed twice.

Governing rules: [ADR-REPO-LINK#3](../../docs/adr/repository/markdown-links.md#rule-adr-repo-link3) (the citation decides the link),
[ADR-REPO-LINK#5](../../docs/adr/repository/markdown-links.md#rule-adr-repo-link5) (one spelling),
[ADR-REPO-LINK#8](../../docs/adr/repository/markdown-links.md#rule-adr-repo-link8) (aligned by tool, never by hand), the **link granularity**
convention in the [ADR index](../../docs/adr/index.md#authoring-conventions) (cite a rule when the sentence invokes one concrete rule, link the
ADR when the context is general, and over-narrowing a general pointer is worse than leaving it doc-level),
[ADR-REPO-COMMENTS#1](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments1) to
[#5](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments5) (a comment of more than one line moves verbatim to its page), and
[ADR-PRIN-ONELIVE](../../docs/adr/principles/one-living-version.md) (change the text and every caller in the same change, leave no old spelling
and no second copy).

Decisions already made by you: the ledger is an `out/` script, not a function; verdicts are sampled at 5% before edits start; Phase 1 is a
one-time cleanup with no standing guard; the placeholder-code fix in `Get-AdrCodesFileMetaFact` comes after Phase 1; code comments are
handled by Phase 2. Phase 2 is settled too (see [Decisions](#decisions-phase-2)): pages stay lossless with explanation articles beside them,
the heads' function help stays in place, tests are out, only clear restatements are deleted, and size thresholds come from the data.

---

## Status at the end of the 2026-10-16 session

Phase 1 is paused. It resumes after Phase 0 and the plan move in `out/plan-claude-plans.md`, because they remove the 274 `.unordered/` rows
and the body-hash drift that every ADR edit causes. Phase 2 has not started.

- Step 1.0 (the edge ledger) and Step 1.1 (the pre-pass) are done. The ledger is `out/adr-link-ledger.csv`, built by
  `out/build-adr-link-ledger.ps1` then `out/prepass-adr-link-ledger.ps1` (both through `out/refresh-ledger.ps1`), 5,203 rows, keyed by
  `Key`.
- Step 1.2 has one pilot slice reviewed, `pipelines` (88 rows: 79 keep, 2 narrow, 7 hold). The verdicts are in the ledger and in
  `out/verdicts/pipelines-overrides.csv`, applied by `out/apply-verdicts.ps1`.
- The analysis is in `out/analysis-adr-link-ledger.txt`. Its recommendations wait for your answer: exclude `.unordered/` from the ledger;
  relax `ADR-REPO-HELP#3` (687 head-text citations) instead of stripping them; replace the 35 chunks with a sample-then-stop review (the ~42
  no-overlap rows, the repeat groups, a 100-row sample of whole links, a 150-row sample of rule rows).
- Steps 1.3 (apply) and 1.4 (verify) have not started, and no document has been edited. The two `narrow` edits are in
  `docs/explanation/flow/no-gate-checks-rules-one-and-four.md`.
- Code built on the way, in `Catzc.Base.QualityGates`: `Get-AdrUsage`, `Get-AdrUsageRow`, `Group-AdrUsage` and their tests (14 pass), plus a
  `TryParse` fix in `Get-AdrCodesFileMetaFact`. `Test-FileMeta` is clean for them; the formatting, link, spelling, glossary and analyzer
  gates have not run on them, and the `TryParse` fix has no regression test for an oversized rule number.

# Phase 1: clean up ADR linking, semantically

Goal: read every declared edge to an ADR, decide what it really points at, and make it say exactly that. An edge that names a numbered rule
but only means "see this ADR" becomes a link to the ADR as a whole. An edge that means one rule stays on that rule. A whole-ADR edge that in
fact leans on one rule is narrowed only when that is clear. An edge whose rule does not say what the sentence claims is retargeted.

## What the repository holds now

Measured with `Get-AdrUsage` on 2026-10-16 (heads of tracked files; JSON-property and sidecar files not scanned):

| Measure                            |  Rows | Of which cite a rule | Whole ADR |
| ---------------------------------- | ----: | -------------------: | --------: |
| `links:` (markdown links in `.md`) | 2,087 |                  670 |     1,417 |
| `adrs:` (citations, code and docs) | 4,999 |                4,679 |       320 |

Markdown links by area: ADR bodies 1,465 (621 to a rule, 844 whole); other docs 621 (49 to a rule, 572 whole); `.claude/` 1.

- The 670 markdown rule links are the review's core. 621 sit in ADR bodies, where a rule link is often a cross-reference and a whole-ADR
  link would do.
- Code comments of more than one line have already moved into comment pages (`docs/references/**/<file>.md`), so their citations are page
  edges and the ledger reaches them as such. The 4,679 rule citations in `adrs:` also include test tags, which name the rule a test proves
  and stay.
- Some rules are linked many times and are probably right to be: `ADR-AZ-DATAMOD#9` (17), `ADR-AZ-LZ#1`–`#6` (about 80 together),
  `ADR-AUTO-TEST#35` (13), `ADR-AZ-NETWORK#1/5/6`. Each is a quick confirm, not a rewrite.
- Several ADRs are linked 9–29 times with a rule on only a few: `ADR-AUTO-DEFAULT` (29 links, only `#6` has a rule), `ADR-AUTO-DEPM` (21,
  `#8`), `ADR-AZ-CLI` (15, `#1`), `ADR-AUTO-PARITY` (17, `#1`). The few rule links among them are the first to check.
- Only one ADR has a single rule, so "a rule link equals the whole ADR" removes almost nothing. The judgement has to be semantic.

## Edge model

An **edge** is one declared reference from a citing place to an ADR, optionally with a rule.

| Form           | Lives in               | Example                                | Edited where                 |
| -------------- | ---------------------- | -------------------------------------- | ---------------------------- |
| Markdown link  | a `.md` body or page   | `[rule text](../x/y.md#rule-adr-x-y3)` | the body                     |
| Prose citation | body or page, unlinked | `ADR-X-Y#3`                            | the text (the aligner links) |
| Test tag       | a Pester `-Tag`        | `'ADR-X-Y#3'`                          | out of scope, rule by design |
| Head `adrs:`   | file head              | `ADR-X-Y#{1,3}`                        | never by hand: derived       |
| Head `links:`  | file head              | `docs/adr/x/y.md#rule-adr-x-y3`        | never by hand: derived       |

Heads are derived from the bodies by `Format-FileMeta`, so the edit is always in the body or page and the head follows.

## Verdicts

Each in-scope edge gets exactly one verdict, decided from the sentence around it and the text of the rule it names:

| Verdict      | When                                                                                                                                        | Edit                                 |
| ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------ |
| **keep**     | The sentence invokes the rule's own claim: a constraint obeyed, a reason given ("because"), a cited prohibition, an exception to that rule. | none                                 |
| **widen**    | The sentence is a pointer or topic mention ("see X for the rationale", an index or list of related ADRs, the ADR's whole thesis).           | rule link becomes the whole-ADR link |
| **merge**    | One file cites three or more distinct rules of the same ADR, or the same rule repeatedly in one section.                                    | one whole-ADR link, or one link kept |
| **narrow**   | A whole-ADR link whose sentence plainly leans on one rule and the ADR has several. Used rarely: over-narrowing is the worse error.          | whole-ADR link becomes the rule link |
| **retarget** | The rule named does not say what the sentence claims (stale after a renumber or a split), and another rule of the ADR does.                 | change the number                    |
| **drop**     | A duplicate of an edge already in the same sentence or section, or a link to the file itself.                                               | remove the link, keep the words      |

Reading signals, in order: what the sentence asserts; whether the rule's summary line states that assertion; whether the surrounding
sentence names the rule's content or only the ADR's topic; how many different rules of the ADR the file cites.

## Steps

### Step 1.0: build the edge ledger

`Get-AdrUsage` reads heads, so it has no line number and no sentence. The review needs both. Build a ledger, one row per edge:
`file, line, form, code, rule, sentence, ruleSummary, verdict, replacement, note`.

- Source the edges from the body with the link scanner the gates already use (`DocumentLinks` behind `Test-Links`), not a new regex. Source
  the rule summary from `Get-AdrRuleSummaryLines`.
- A script under `out/` writes `out/adr-link-ledger.csv`, regenerated after edits so a rerun shows what is left. It is not a function.
- Measure the page and prose-citation shares, and set the review slices from the real counts.

**Done on 2026-10-16.** `out/build-adr-link-ledger.ps1` wrote `out/adr-link-ledger.csv`: 5,182 rows across 835 files, with `Verdict`,
`Replacement` and `Note` empty. It reads markdown links with `DocumentLinks` one prose line at a time (so it repeats only fence tracking),
and the unlinked citations with the citation pattern the head tooling uses. It skips tests, assets, vendor and compiled output, the diagram
text under `docs/.assets/` (435 generated files that would have added 16,900 rows), 35 unregistered placeholder citations and 476 ADRs'
citations of themselves.

| Form                        |  Rule | Section | Whole |
| --------------------------- | ----: | ------: | ----: |
| markdown link               | 1,084 |      17 | 1,930 |
| prose citation              | 1,264 |       - |   178 |
| head help text (PowerShell) |   503 |       - |   182 |
| code-comment                |    21 |       - |     3 |

- By area: ADR bodies 2,629 rows, explanation 1,031, code 709, references 351, other `.md` 312, other docs 150.
- Generated files carry 268 of the rows (`docs/adr/index.md` 180, the glossary 77): their edits belong in the source, so Step 1.3 leaves
  them alone and the `Generated` column marks them.
- The unit is an occurrence, not a file and target pair: the 1,084 markdown rule links are about 670 distinct pairs, and a rule is often
  linked several times in one file.
- Two kinds the plan did not name: 17 **section** links (to a heading of an ADR that is not a rule), which the review judges like the rest,
  and 685 **head-text** citations, in the `description` of PowerShell heads. D2 leaves that text in place, so those are reviewed for their
  link only. [ADR-REPO-HELP#3](../../docs/adr/repository/function-help.md#rule-adr-repo-help3) says a citation is never part of the help text,
  so these 685 may also be findings against HELP#3 rather than links to tidy; the review decides.

### Step 1.1: mechanical pre-pass (suggests, never decides)

Cheap signals that sort the ledger so review time goes where judgement is needed:

- files citing three or more distinct rules of one ADR (merge candidates);
- ADRs linked often with a rule on only a few of them (widen candidates);
- rule links in an "index", "related", or "see also" list (widen candidates);
- rules linked from many places with consistent wording (keep, confirm quickly);
- rules whose summary shares no words with the citing sentence (retarget candidates).

**Done on 2026-10-16.** `out/prepass-adr-link-ledger.ps1` adds three columns to `out/adr-link-ledger.csv` and keeps every other column,
verdicts included, so it is safe to rerun: `Slice` (the domain folder of the cited ADR), `Signals` and `Triage`.

| Triage    |  Rows | Meaning                                                                                                              |
| --------- | ----: | -------------------------------------------------------------------------------------------------------------------- |
| `check`   | 1,539 | A sharp signal fired: `NOOVERLAP`, `REPEAT`, `MOSTLYWHOLE`, `SECTION`, `HEADTEXT`, `MULTI5`, or `MULTI` with `LIST`. |
| `read`    | 2,571 | No sharp signal; the sentence is read as written.                                                                    |
| `confirm` |   804 | `POPULAR` only: a rule cited 8 or more times across 4 or more files; a quick confirm.                                |
| `skip`    |   268 | Generated files (`docs/adr/index.md`, the glossary): edited in their source.                                         |

Signal counts: `POPULAR` 1,383, `LIST` 1,013, `HEADTEXT` 685, `MULTI` 533, `MULTI5` 380, `REPEAT` 122, `NOOVERLAP` 96, `MOSTLYWHOLE` 23,
`SECTION` 17. The sharp ones are the small set to look at first: `NOOVERLAP` (96, retarget), `REPEAT` (122, merge), `MOSTLYWHOLE` (23, widen
across `ADR-AUTO-DRYRUN`, `ADR-AUTO-UVPY`, `ADR-AUTO-ZERO`, `ADR-AUTO-ENTERP`, `ADR-AUTO-PKGMGR`, `ADR-PROC-KAIZEN` and a few more).

Two choices to know: `MULTI` is not raised for files under `docs/adr/azure/caf/` and `docs/adr/azure/waf/`, because those ADRs hold one rule
per vendor item and citing many of them is their design; and `MULTI` alone (three or four distinct rules) is only a hint, because a topic
page often has to name several rules. A `narrow` signal is not computed: it needs every rule's summary, and `narrow` is meant to be rare.

Editable rows per slice (the cited ADR's domain), with the chunk count at about 150 rows a chunk for Step 1.2:

- automation 1,369 rows (9 chunks), azure 1,005 (7), design 555 (4), repository 545 (4), flow 442 (3), pwsh 339 (2).
- principles 185, configuration 138, process 117, research 114, pipelines 88, and github with thesis 17: one chunk each (6).

That is about 35 chunks. Chunk boundaries fall between files, so one file's edges are never split across two reviewers.

### Step 1.2: semantic review

Review in slices by the ADR cited, so the reviewer reads each rule text once. One slice is one domain folder of the target ADRs, in this
order: `azure` (heaviest rule linking), `automation`, `pwsh`, `repository`, then the rest.

- Reviewers read the rule text and the sentence, then fill `verdict`, `replacement`, and a one-line `note` in the ledger. They edit no
  document in this step.
- Delegation uses `catzc-worker`, one slice per brief, each owning only its own ledger file under `out/`. Nothing is launched until you ask.
- You read **5%** of the `keep` and `widen` verdicts per slice before Step 1.3 starts. The rate goes up for a slice where more than a few
  are wrong.

**Pilot done on 2026-10-16: the `pipelines` slice (88 rows), reviewed inline.** Verdicts are in the ledger (`Verdict`, `Replacement`,
`Note`, `ReviewedBy`) and in `out/verdicts/pipelines-overrides.csv`, applied by `out/apply-verdicts.ps1`, which keys on `Key` so a rebuild
keeps them. Result: 79 keep, 2 narrow, 7 hold, 0 widen, 0 merge, 0 retarget, 0 drop.

- Every rule citation in a "Why it holds" bullet states the rule it cites; every whole-ADR link sits in a "See also", "Related", "Context"
  or index line and is a general pointer. The sharp signals were false alarms here: the one `MOSTLYWHOLE` row is a sentence about that
  specific rule.
- **narrow (2):** prose that says "ADR-PIPE-NAME rules 1, 2, 3, 4 and 6" and "rule 4" cites specific rules without the `#n` spelling.
- **hold (7), a decision for you:** the help text of `Test-Pipelines.ps1` carries citations, and
  [ADR-REPO-HELP#3](../../docs/adr/repository/function-help.md#rule-adr-repo-help3) says a citation is never part of help text. 685 head-text
  rows in the ledger are in the same position, so this is a rule against practice, not seven rows. Either strip them (the derived `adrs`
  already lists them) or relax HELP#3.
- **Scope, a decision for you:** 6 rows come from `.unordered/` shelf plans. They are throwaway documents; exclude `.unordered/` from the
  ledger.
- **Tool fixes the pilot forced:** the context of a list item or table row is now that item or row, and `LineText` holds the exact line, so
  the cited sentence is visible. Without it a reviewer cannot tell which bullet cites which rule.
- **Effect on the plan:** the yield is low where links are already deliberate. To spend review time where a verdict can change,
  `markdown`/`whole` links (about 1,930 rows, nearly all general pointers) can take an automatic `keep`, leaving the rule-form edges, the
  prose citations and the section links for a human-quality read.

### Step 1.3: apply

One file at a time, with the Edit tool, never a script sweep. After each file:

1. `Format-Links` on the file, so the form is canonical (ADR-REPO-LINK#8).
2. `Format-FileMeta` on the file, so the head follows the body.
3. `Test-Links` and `Test-FileMeta` on the file.
4. Mark the ledger row applied.

Peer sessions edit this tree, so check `git status` for the file first and message before editing a file with someone else's changes.

### Step 1.4: verify

- `Get-AdrUsage` before and after: the rule-link count falls by the widen and merge count, whole-ADR links rise by the same, and no
  unregistered code appears.
- Re-run the ledger: no row without a verdict, no row unapplied.
- `Test-Links`, `Test-FileMeta`, `Test-Glossary`, `Test-Spelling` on the changed files.
- After Phase 1: fix the seven code heads that hold the `ADR-X` and `ADR-WIDGET-GADGET` placeholders by making `Get-AdrCodesFileMetaFact`
  drop unregistered codes from held lists.

## Phase 1 out of scope

- Test tags and the `defines:` lists of ADRs.
- Derived head lists (`adrs:`, `links:`); they follow the bodies.
- Renaming or renumbering rules, and any rewording of an ADR's decisions. A retarget changes a number in a citing sentence, never the rule.
- JSON-property and sidecar files, which `Get-AdrUsage` does not scan.
- A standing guard such as "three or more rules of one ADR in a file": this is a one-time cleanup.

---

# Phase 2: larger text out of source files into sister pages

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

[ADR-REPO-COMMENTS#2](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments2) says a moved comment is a section of the page that
holds its lines exactly and that the view puts back unchanged, and [#3](../../docs/adr/repository/comments-in-docs.md#rule-adr-repo-comments3)
puts every page under `docs/references/`. Sorting text into `docs/explanation/` therefore cannot be done by lifting a section out of a page,
because the round-trip would no longer reproduce the file. Two ways to reconcile (decision D1):

- **(a) Keep the page lossless; write the explanation beside it.** The comment page stays the sister page and keeps its sections. A new
  `docs/explanation/<area>/<topic>.md` article carries the _why_ that several pages share, and the page's section links to it. No rule
  changes. The text exists twice only where the page holds the verbatim comment and the article holds the synthesis, which is a second copy
  of some words. This is the cheapest and keeps `Test-Comments` as is.
- **(b) Let a section be promoted.** Amend COMMENTS#2/#3 so a section may be marked `promoted: <article>`, the view reads its text from the
  article, and `Test-Comments` follows the pointer. One living copy, but it changes a rule, the view builder and the gate in one change.

Decided: (a). (b) is revisited only if the duplication proves a real burden.

## Steps

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

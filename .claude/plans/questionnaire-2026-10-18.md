---
plan:
  status: active
  kind: questionnaire
  reviewed: 2026-10-18
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/questionnaire-2026-10-18.md"
    folder: plans
    name: questionnaire-2026-10-18
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
      - ADR-PWSH-VERBS#2
---

# Questionnaire, 2026-10-18: the open decisions of the plans

One item per open question, the context a reader needs, the options, and a Decision line filled in as the user answers. Items D01 to D16
come from task004 (D14 was answered 2026-10-17); D17 to D20 are the questions the executions of 2026-10-17 raised. The first option of each
is the recommendation.

## Items

- D01 Module model choice (a): the resolver lives in a small module above Languages and returns identity only; needs and order stay in
  ModuleSystem. Built that way. Options: confirm as built; move needs and order into the resolver. Decision: confirm as built (2026-10-18,
  the recommendation).
- D02 Choice (b): the track key is `execution_engines`, the table is `layout`, "kind" stays out of the ADR text until the role rename.
  Options: confirm; rename now. Decision: confirm (2026-10-18, the recommendation).
- D03 Choice (c): rule 6 covers check and test handlers only; `LoadedModule` dropped with `BaseModule`. T011 then builds the handler ids.
  Options: confirm; widen rule 6 to every handler. Decision: confirm (2026-10-18, the recommendation).
- D04 `Copy-Automation` selects the full profile by default and no longer copies `.scriptanalyzer`. Options: confirm; copy the analyzer
  rules too. Decision: confirm (2026-10-18, the recommendation).
- D05 The run-mode slides' minimap rebuild redrew every slide's minimaps; Test-Links and Test-GeneratedFiles are clean. Options: keep the
  rebuild; revert to the committed minimaps. Decision: keep the rebuild (2026-10-18, the recommendation).
- D06 `idleCompaction: false` sits in the gitignored local settings. Options: keep it local, a per-person preference; check it in for every
  checkout. Decision: keep it local (2026-10-18, the recommendation).
- D07 The gallery PDF of all assets is about 684 MiB against a 30 MiB chat cap, a factor of 20. Options: no `--parts` flag, a side script
  splits when a review needs it; a `--parts <n>` flag in the builder. Decision: no flag (2026-10-18, the recommendation).
- D08 The format cache stamp rule for ADR-REPO-FORMAT: an engine's stamp contains its own tool pin and its own settings files, nothing else,
  with a test that every declared input invalidates. Options: yes, that rule; a stamp over every engine's inputs together. Decision: yes,
  that rule (2026-10-18, the recommendation).
- D09 Lazy types and the source-console janitors: the janitors trip the lookup hook at import, so lazy loading pays off only for bundle,
  -SkipJanitors and idle sessions. Options: run the janitors after the first prompt; keep them at import. Decision: run the janitors after
  the first prompt (2026-10-18, the recommendation).
- D10 Layers P4, the folder move of `automation/` to `pwsh`, a `git mv` the user runs in a quiet window. T011 and T018 are still open, T017
  is done. Options: hold until T011 and T018 are green, then the user names the window; name the window now. Decision: hold until T011 and
  T018 are green (2026-10-18, the recommendation).
- D11 Unboxing P4 (three-pass walk) and P5 (class-lookup GlobPattern objects built once), each with a 15 percent bar. Options: stay closed,
  the measured wins are in; go, measure first. Decision: stay closed (2026-10-18, the recommendation).
- D12 `Build-Readme` on an unchanged tree: 304 ms first call, 109 ms warm; a stamp would add `with_inputs_sha` to about 55 committed README
  copies. Options: record not skippable; stamp the README meta block. Decision: record not skippable (2026-10-18, the recommendation).
- D13 `Format-Code` and `automation/.compiled`: Test-Formatting flags the compiled types `.json`. Options: skip the folder as generated
  output; amend the formatting ADR to cover it. Decision: skip the folder (2026-10-18, the recommendation).
- D15 Test-Glossary's about 195 bare-term findings in plan text ("full suite", "gate", "phase", "layer", "source", "slot"). Options: fix per
  plan when next edited; exempt plan files from the vocabulary gate. Decision: fix per plan when next edited (2026-10-18, the
  recommendation).
- D16 Materialization choices 1 to 3 were taken in Q66 to Q70; T026 writes ADR-AUTO-MATERIAL. Options: confirm, nothing reopens; reopen one
  choice. Decision: confirm, nothing reopens (2026-10-18, the recommendation).
- D17 `Assert-Wait` throws only for a bad argument and otherwise lets go, while ADR-PWSH-VERBS#2 and #3 make an Assert- function one that
  stops the caller, and the file sits in the `assert` subkind. Options: rename to a watch verb, `Watch-Blocking`, assert subkind untouched;
  a VERBS#7 exemption for a watchpoint that never stops. Decision: rename to Watch-Blocking (2026-10-18, the recommendation).
- D18 ADR-AUTO-CACHE and type-level statics: the unboxing work keeps class-level static caches in the compiled types. Options: no sentence,
  the ADR stays as it is; one sentence saying ADR-AUTO-CACHE does not cover type-level statics. Decision: no sentence (2026-10-18, the
  recommendation).
- D19 C3 pilot command contracts: which commands get the first hand-written `.command.yml` files. Options: the draft's set, the 8
  Catzc.Base.Languages and 5 Catzc.Base.Contracts commands; the cats entry point's commands; both sets. Decision: the draft's set
  (2026-10-18, the recommendation).
- D20 The `note` kind in file-kinds.yml: no tracked file reaches it since .unordered was emptied, and the reachability test is red on it.
  Options: delete the kind, the unordered track's fragments are untracked; keep it and exempt it from reachability. Decision: delete the
  kind (2026-10-18, the recommendation).

---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [importer.sh, pwsh/Catzc.Base.QualityGates]
---

# Debt import path: a parse check before the next import, and list parameters from bash

A stray character in an import-path file breaks every session's next import, and nothing checks it first; and `importer.sh` cannot pass a
list parameter. Step 2 edits the import path, so it runs as a burst: `hold` to every live session first, `go` after one fresh full import.
The chunk owns the new command with its test and page, and `importer.sh` with its test.

## Open steps

1. [ ] Susan from HR: hindsight 031350, "If only someone had made the instant check a command": no command, capability or how-to
       parse-checks a module `.ps1` or a `.yml` on the import path before the next import (`catzc-check` has no parse step; `catzc-verify`
       step 1 asks for one with no command), so one stray colon breaks every session first. Cost: an outage for every live session. Change:
       one command in `pwsh/Catzc.Base.QualityGates` that parses named `.ps1`/`.psm1`/`.yml` files without importing, with its test and
       page. Check: `Invoke-TestFile` on its test, and one live run on a file with a stray `'` reports the line.
2. [ ] Susan from HR: hindsight 031350, "If only importer.sh knew lists": the lookup carries a list flag per parameter, yet
       `importer.sh:98-100` passes only switch, int, bool and single values, so a list parameter is the one variant cats cannot call from
       bash. Cost: every list-taking command is uncallable from bash. Change: a list parameter's values pass as one PowerShell array, with a
       test case. Check: the `importer.sh` test file under `Invoke-TestFile`, then one fresh full import.
3. [ ] After step 1: `.claude/skills/catzc-verify/SKILL.md` step 1's parse clause names the new command in place of "parse every
       `.ps1`/`.psm1`", merged into the existing sentence, the file kept at 10 lines. Check: `Test-AgentDefinitions` reports 0 issues.

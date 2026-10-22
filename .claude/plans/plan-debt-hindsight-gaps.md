---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets:
    [
      docs/drs/automation/pwsh/pester-testing.md,
      docs/how-to/getting-started/pwsh/run-tests-and-checks.md,
      docs/references/pwsh,
      .claude/skills,
    ]
---

# Debt hindsight gaps: what the 2026-10-22 hindsight run found nothing in the tree answers

The `2020-hindsight` run of 2026-10-22 logged 57 lines; nine name a gap (no doc, page or capability line says it) and seven a place where
the tree contradicts itself. Each is closed by one doc sentence, one reference page or one capability line, a file at a time.

## Why its value

Every gap cost a session a wrong guess on 2026-10-22 (`Test-Drs` three times, an `@(Get-X)[0]` bullet that broke a rule); one line in the
right file saves the next session that guess.

## Decided (the orchestrator, delegated, 2026-10-22)

- Doc and page fixes are taken; capability lines land only where the skill file keeps its roof, the rest come back as asks; the agent design
  of the hindsight readers (a read-only helper per hindsight file) and `docs/references/pwsh/CLAUDE.md` stay with the user.
- **The Mock gap is dropped as false:** the learning in `learned78d9be.md` line 71 says a Pester `Mock` body does not see the `It` block's
  locals, but on the vendored Pester 5.7.1 a `Mock` defined in the `It` sees them, called directly and with `-ModuleName` (catzc-e3,
  2026-10-22, `out/mock-scope.Tests.ps1`, 3 of 3 green); no sentence is added.

## Open steps

- [ ] `docs/references/pwsh/catzc-base-docs.md`: the decision-record responsibility (its lead, "What the module does", responsibility 4 and
      the Division rows for `Build-DrsIndex`, `Get-DrsRuleSet`, `Get-CatsDrsRuleIds`, `Get-DrsCitationMap`, `Get-DrsDomainEdges`,
      `ConvertTo-DrsDomainDiagram`, `Test-DrsRegistry`, `Test-DrsEngineNeutrality` and the three drs configs) leaves it for one pointer to
      `catzc-base-drs.md`, written on 2026-10-22 (catzc-54; its link from `index.md` clears `Test-Links` once the user commits the article,
      task-user-runs-and-commits). One living version (PDR-ONELIVE). (check: `Test-Links` and `Test-Markdownlint` on `catzc-base-docs.md` at
      0, and no `Drs` command named in it outside the pointer)
- [ ] `docs/references/pwsh/catzc-base-exporter/Build-Modules.ps1.md`: one sentence, a case-only rename git does not track drops the
      module's files from the index check, so the build makes nothing (the VSCode case on 2026-10-22). (check: `Test-Comments` and
      `Test-Links` on the page at 0)
- [ ] `docs/references/pwsh/catzc-base-quality-gates/Export-Comments.ps1.md` line 23 and `private/Get-CommentScope.ps1.md` line 17 say test
      files are out of scope, while pages for test files exist: the code read, and the pages or the stray test pages made to agree. (check:
      `Test-Comments` at 0, the finding on which side was wrong reported first)
- [ ] `.claude/skills` lines, each in the capability it belongs to and only where the file keeps its roof: a script holding backslashes is
      written with the Write tool, never a bash heredoc; a line pre-approving agent behaviour, or a `sed -i` delete, goes to the user; a
      gate run's detail is grepped from `tests.csv` and `files-shard-*.json`, never printed whole; a review over several ADR areas is one
      `drs-reviewer` per ADR set; a bats test passes a path through `cygpath -m` (as `importer.sh` lines 48 and 49); `Format-Code` formats
      only `-Path`, so an imprint step writing other files formats them itself; a new test's code file belongs to its owner. A line that
      does not fit comes back as an ask. (check: `Test-AgentDefinitions` at 0)

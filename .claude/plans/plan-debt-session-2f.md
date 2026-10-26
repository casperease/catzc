---
plan:
  status: active
  value: medium
  reviewed: 2026-10-26
  class: debt
  targets: [python/diagrams, pwsh/.internal/assets, .claude/skills/catzc-verify]
---

# Session debt: three traps from the wording and reference-page work, each shrunk at its source

Each step removes a trap a session hit on 2026-10-26, so the next session neither reads about it nor rediscovers it.

## Open steps

1. [ ] Kit contract paths derived, not spelled: `minimap_contract.py` and `tests/test_query_rows.py` resolve their schema paths through
       `module_paths.py` from the module's full name, so a contract-group rename needs no kit edit. Check:
       `uv run pytest python/diagrams/tests` passes, and grep finds no `contracts/catzc/` literal in `python/diagrams`.
2. [ ] Lock-only burst: `Invoke-StagedBurst` accepts `-Run` with nothing staged and holds the run lock only. Check:
       `pwsh -NoProfile -File pwsh/.internal/assets/Invoke-StagedBurst.ps1` with an empty staged folder and one command runs that command
       under the run lock.
3. [ ] The catzc-verify line: a new L1 `integrity` block needs its check in a manual-test-plan category page. Check: `Test-AgentDefinitions`
       at 0 and the skill within its 10 lines.

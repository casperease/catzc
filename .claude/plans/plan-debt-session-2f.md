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

## Open questions

- Should the diagram kit derive its contract schema paths (`minimap_contract.py`, `tests/test_query_rows.py`) through `module_paths.py` from
  the module's full name, so a contract-group rename needs no kit edit? Recommendation: yes, one resolver for the path, as the pwsh side
  already does.
- Should `Invoke-StagedBurst` take `-Run` commands with nothing staged, holding the run lock only, so a re-render needs no unchanged carrier
  file? Recommendation: yes, a lock-only burst is the common re-render case.
- Should the `catzc-verify` capability gain one line: a new L1 `integrity` block needs its check in a manual-test-plan category page?
  Recommendation: yes, one line instead of a failed final check.

## Open steps

1. [ ] Kit contract paths derived, not spelled. Check: `uv run pytest python/diagrams/tests` passes, and grep finds no `contracts/catzc/`
       literal in `python/diagrams`.
2. [ ] Lock-only burst. Check: `pwsh -NoProfile -File pwsh/.internal/assets/Invoke-StagedBurst.ps1` with an empty staged folder and one
       command runs that command under the run lock.
3. [ ] The catzc-verify line. Check: `Test-AgentDefinitions` at 0 and the skill within its 10 lines.

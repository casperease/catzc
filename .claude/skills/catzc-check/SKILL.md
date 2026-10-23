---
name: catzc-check
description:
  Run one quality gate or test file and report its verdict verbatim; for plan-clear, link-fixer, gate-runner and catzc-drone; input is the
  gate name with its paths, or a test file path.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-check

1. One gate per run, through catzc-run: `Invoke-TestFile -Path <file>` for a test file, or the quality gate the brief names, with its paths
   (`Test-Links -Path <files>`, `Test-AgentDefinitions`); `Test-DrsRegistry` checks the decision records, registry-wide with no `-Path`, and
   `Test-Parsing -Path` takes files and `Test-Diagrams` diagram paths, never a folder; the one Python test call is
   `Invoke-PythonTest <Pascal.Dotted>`, the module's own `tests/` found first.
2. Read the output file; the verdict is the gate's own summary line and its report path; failing lines are pasted verbatim, at most 20,
   never paraphrased; a run's detail is grepped from its artifacts (`tests.csv`, `files-shard-*.json`), never a whole gate output printed.
3. No output line, no verdict: a pass is never claimed unseen; a timeout is reported as such, and a gate is never re-run with a larger limit
   or on fewer files to make it pass.

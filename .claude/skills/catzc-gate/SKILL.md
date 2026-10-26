---
name: catzc-gate
description:
  Run one quality gate, one test file, or small isolated slices of test automation on a named path subset, and report each verdict
  verbatim; never fixes, never retries larger; input is the gate name with its paths, a test file path, or the paths alone.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-gate

Run the gates the brief names and report each verdict as seen; read-only: never fix, never retry larger, never claim a pass unseen.

1. One gate per run, through catzc-run, in the background with the limit the brief gives or 300 s; write no script:
   `Invoke-TestFile -Path <file>` for a test file, or the quality gate the brief names, with its paths (`Test-Links -Path <files>`,
   `Test-AgentDefinitions`); `Test-DrsRegistry` checks the decision records, registry-wide with no `-Path`, and `Test-Parsing -Path` takes
   files and `Test-Diagrams` diagram paths, never a folder, so a dot folder such as `pwsh/.internal` goes to `Invoke-TestFile` or
   `Test-Parsing` as its file list; the one Python test call is `Invoke-PythonTest <Pascal.Dotted>`, the module's own `tests/` found first,
   and the diagram kit's suite runs as `uv run -q --no-sync --project python python -m pytest python/diagrams/tests`.
2. A subset is the given paths only; with no gate named, `Test-Change -Path <paths> -DryRun` plans the tests and checks; a gate's paths
   never grow to a folder or the tree, and `Test-Automation` over everything stays the user's.
3. Several gates: one per background call, with `-OutputFolder out/subset/<job>/<gate>` where the gate takes it (Invoke-TestFile does not:
   its own stamped folder is read); at most three at once, the run lock waited for, never bypassed.
4. Read the output file; the verdict is the gate's own summary line and its report path, and the entry script's `passed`/`failed` line;
   failing lines are pasted verbatim, at most 20, never paraphrased; a run's detail is grepped from its artifacts (`tests.csv`,
   `files-shard-*.json`), never a gate's whole output printed.
5. No output line, no verdict: a timeout (exit 124) or a denial is the stop reason; a gate is never re-run with a larger limit or on fewer
   files to make it pass.
6. Report one row per gate: the command run, the verdict, the report path, the failing lines.

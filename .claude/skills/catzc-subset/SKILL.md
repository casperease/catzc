---
name: catzc-subset
description:
  Run small isolated background slices of test automation (Test-Spelling, Test-Links, a test file, …) on a named path subset, one verdict
  per gate; for every robot that runs catzc-check; input is the paths and, optionally, the gates.
user-invocable: false
allowed-tools: Bash, Read
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# catzc-subset

1. The subset is the given paths only; with no gate named, `Test-Change -Path <paths> -DryRun` plans the tests and checks; a gate's paths
   never grow to a folder or the tree, and `Test-Automation` over everything stays the user's.
2. One gate per background call through catzc-run, with `-OutputFolder out/subset/<job>/<gate>` where the gate takes it (Invoke-TestFile
   does not: its own stamped folder is read); at most three at once, the run lock waited for, never bypassed.
3. Each output is read as catzc-check says; report one row per gate: command, verdict, report path, failing lines verbatim.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-RUNSNEVERWAIT
      - ADR-AUTO-PY-EVERYFILETYPECHECKED
---

# A busy test run uses a snapshot and every python file is type checked

This article is one rule: [ADR-AUTO-TEST-RUNSNEVERWAIT](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait) and
[ADR-AUTO-PY-EVERYFILETYPECHECKED](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked) merged into
one. It holds nothing beyond what those two rules say.

A test run never waits for another: the first run owns the working folder and a run that starts while another holds it runs in a verified
snapshot. Every `.py` file the repository holds is type-checked by pyright, in one mode for the gate and the editor alike: `python.yml`'s
`type_checking`, `standard` by default, run through the `Test-PythonTypes` quality gate.

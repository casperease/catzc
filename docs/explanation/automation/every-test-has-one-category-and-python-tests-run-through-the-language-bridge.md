---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-ONECATEGORY
      - ADR-AUTO-PY-LANGUAGEBRIDGE
---

# Every test has one category and python tests run through the language bridge

This article is one rule: [ADR-AUTO-TEST-ONECATEGORY](../../drs/automation/test-automation.md#rule-adr-auto-test-onecategory) and
[ADR-AUTO-PY-LANGUAGEBRIDGE](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-languagebridge) merged into one. It holds
nothing beyond what those two rules say.

Every test is classified into one category, logic or integrity, carried as a mandatory tag: a logic test must not read a shipped asset and
an integrity test exists precisely to read them. `Test-Automation` runs the Python tests through the language bridge the Go tests run
through: discovery maps each Python test folder to its catzc module, and the bridge turns every top-level Python test into one test of the
run, tagged `L2`.

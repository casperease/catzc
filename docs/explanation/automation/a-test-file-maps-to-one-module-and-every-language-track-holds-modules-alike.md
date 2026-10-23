---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-TESTFILE
      - ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE
---

# A test file maps to one module and every language track holds modules alike (ADR-AUTO-TEST-TESTFILE + ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE)

This article is one rule: [ADR-AUTO-TEST-TESTFILE](../../drs/automation/test-automation.md#rule-adr-auto-test-testfile) and
[ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](../../drs/automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike) merged into
one. It holds nothing beyond what those two rules say.

A test file is one file of tests that discovery maps to one catzc module, a module's own test file under its `tests/` folder or a test
folder of another test language, and it is the unit a test run schedules, sharded whole and never split across workers. Every language track
holds its modules the same way: a module is a non-dot folder directly under the track's root, named by the folder, with the track's own test
holder declared apart from the modules.

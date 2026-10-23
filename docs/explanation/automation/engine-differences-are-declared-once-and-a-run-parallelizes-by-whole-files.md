---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE
      - ADR-AUTO-TEST-FILEPARALLELISM
---

# Engine differences are declared once and a run parallelizes by whole files

This article is one rule:
[ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce) and
[ADR-AUTO-TEST-FILEPARALLELISM](../../drs/automation/test-automation.md#rule-adr-auto-test-fileparallelism) merged into one. It holds
nothing beyond what those two rules say.

Everything that differs between the engines is a property of its `ExecutionEngine`, declared once: how its executable is named and located,
the script files it runs, its shebang, its non-interactive start, how it loads an entry script and runs a command, its quoting, its strict
mode and its time safeguard. `Test-Automation` parallelizes at whole-file granularity across worker processes, each worker loading the
modules through its run's entry script.

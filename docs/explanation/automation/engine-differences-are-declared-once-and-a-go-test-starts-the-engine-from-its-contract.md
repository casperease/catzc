---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE
      - ADR-AUTO-GO-BLACKBOXTESTS
---

# Engine differences are declared once and a go test starts the engine from its contract

This article is one rule:
[ADR-AUTO-ENGINE-DIFFERENCESDECLAREDONCE](../../drs/automation/execution-engines.md#rule-adr-auto-engine-differencesdeclaredonce) and
[ADR-AUTO-GO-BLACKBOXTESTS](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-blackboxtests) merged into one. It holds nothing
beyond what those two rules say.

Everything that differs between the engines is a property of its `ExecutionEngine`, declared once: how its executable is named and located,
its shebang, its non-interactive start, how it loads an entry script and runs a command (`StartArguments`), its quoting, its strict mode and
its time safeguard. A Go test is a black-box test that starts the engine from the contract its runner sets, `CATZC_ENGINE_EXECUTABLE` with
the `CATZC_ENGINE_START` arguments.

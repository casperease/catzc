---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PY-BLACKBOXTESTS
      - ADR-AUTO-ENGINE-STARTENVIRONMENT
---

# A python test starts the engine from the engine start environment

This article is one rule: [ADR-AUTO-PY-BLACKBOXTESTS](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-blackboxtests)
and [ADR-AUTO-ENGINE-STARTENVIRONMENT](../../drs/automation/execution-engines.md#rule-adr-auto-engine-startenvironment) merged into one. It
holds nothing beyond what those two rules say.

A Python test is a black-box test under the contract the Go tests follow: it starts the engine from `CATZC_ENGINE_EXECUTABLE` with the
`CATZC_ENGINE_START` arguments and asserts on output and exit codes. A black-box test in another language starts the engine from the engine
start environment its runner sets, `CATZC_ENGINE`, `CATZC_ENGINE_EXECUTABLE`, `CATZC_ENGINE_ENTRY` and `CATZC_ENGINE_START`, never from a
hardcoded command.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ENGINE-CHILDPROCESSES
      - ADR-AUTO-PY-BLACKBOXTESTS
---

# Test workers start child processes and python tests start the engine from its environment (ADR-PWSH-ENGINE-CHILDPROCESSES + ADR-AUTO-PY-BLACKBOXTESTS)

This article is one rule: [ADR-PWSH-ENGINE-CHILDPROCESSES](../../drs/automation/pwsh/pwsh-engine.md#rule-adr-pwsh-engine-childprocesses) and
[ADR-AUTO-PY-BLACKBOXTESTS](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-blackboxtests) merged into one. It holds
nothing beyond what those two rules say.

Processes are started deliberately, never from a hardcoded command. The Pester workers of a test run, the isolated runs of
`Test-InIsolation` and the snapshot priming each start a child pwsh. A Python test is a black-box test that starts the engine from
`CATZC_ENGINE_EXECUTABLE` with the `CATZC_ENGINE_START` arguments, which load the run's entry and end in the test's command, and asserts on
output and exit codes.

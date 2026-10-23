---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-PWSH-ENV-SHAREDPROCESSENVIRONMENT
      - ADR-AUTO-TEST-ONESCHEDULINGPOOL
---

# Runspaces share one environment block and the test pool keeps serial tests apart

This article is one rule:
[ADR-PWSH-ENV-SHAREDPROCESSENVIRONMENT](../../drs/automation/pwsh/environment-variable-mechanics.md#rule-adr-pwsh-env-sharedprocessenvironment)
and [ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool) merged into one. It
holds nothing beyond what those two rules say.

Runspaces share one process environment block, so never read or write `$env:` inside `ForEach-Object -Parallel` or a runspace worker to
coordinate work: concurrent access races. Pass values in with `$using:` and aggregate through pipeline output or a thread-safe collection. A
test run applies the same care to the machine: the parallel shards and the greedy phase share one worker pool, and tests that must not share
the machine with it are tagged for the serial phase that runs after both.

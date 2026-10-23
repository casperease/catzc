---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-PROCESSTRIPWIRE
      - ADR-AUTO-FAILFAST-BOUNDEVERYWAIT
---

# A tripwire fails any real process in l0 and l1 and every wait is bounded

This article is one rule: [ADR-AUTO-TEST-PROCESSTRIPWIRE](../../drs/automation/test-automation.md#rule-adr-auto-test-processtripwire) and
[ADR-AUTO-FAILFAST-BOUNDEVERYWAIT](../../drs/automation/fail-fast-with-asserts.md#rule-adr-auto-failfast-boundeverywait) merged into one. It
holds nothing beyond what those two rules say.

A runtime tripwire enforces that L0 and L1 launch no real process: `Test-Automation` sets `CATZC_BLOCK_REAL_PROCESS` and `Invoke-Executable`
throws instead of launching, so a mock that fails to intercept fails loudly. Every wait is bounded as well: every external call and every
unbounded piece of work runs inside a time safeguard, so a hang fails fast with a message naming the limit, the limits living in one config,
`timeouts.yml`.

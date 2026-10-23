---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-REALISENEVERREDEFINE
      - ADR-AUTO-TEST-RUNSNEVERWAIT
---

# Each layer realises the one above and a test run never waits for another

This article is one rule: [ADR-AUTO-LAYERS-REALISENEVERREDEFINE](../../drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)
and [ADR-AUTO-TEST-RUNSNEVERWAIT](../../drs/automation/test-automation.md#rule-adr-auto-test-runsneverwait) merged into one. It holds
nothing beyond what those two rules say.

Each layer realises the one above it and never redefines it: automation, contract, language, engine and importer, read top down as what, its
interface, how it is written, how it runs and how it is assembled. The test run is built the same way, without queues: it never waits for
another, the first run owning the working folder and a run that starts while another holds it using a verified snapshot.

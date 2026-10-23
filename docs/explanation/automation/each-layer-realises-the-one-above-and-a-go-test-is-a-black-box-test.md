---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-REALISENEVERREDEFINE
      - ADR-AUTO-GO-BLACKBOXTESTS
---

# Each layer realises the one above and a go test is a black box test

This article is one rule: [ADR-AUTO-LAYERS-REALISENEVERREDEFINE](../../drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)
and [ADR-AUTO-GO-BLACKBOXTESTS](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-blackboxtests) merged into one. It holds
nothing beyond what those two rules say.

Each layer realises the one above it and never redefines it: automation, contract, language, engine and importer, read top down as what, its
interface, how it is written, how it runs and how it is assembled. A Go test sits at the engine end of that order as a black-box test,
starting the engine from the contract its runner sets and asserting on output and exit codes, never on the engine's internals.

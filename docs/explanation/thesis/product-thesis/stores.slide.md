---
catzc:
  config:
    pattern: image
    deck: product-thesis
    order: 3
---

# Catzc writes its domain, reads fact sources, meets state machines

## Image

.assets/truth-stores/diagram.drawio.png

## Caption

Three kinds of truth store (ADR-THES-STORES-THREEKINDS): catzc writes its responsibility domain, the repository at one commit
(ADR-THES-STORES-RESPONSIBILITYDOMAIN); reads a fact source and never writes it (ADR-THES-STORES-FACTSOURCEREADONLY); and meets a state
machine with facts and takes its verdict (ADR-THES-STORES-STATEMACHINE, ADR-THES-STORES-RECONCILEFACTS).

## Notes

The scattered truth of the previous slide, sorted. Every store catzc touches is one of three kinds, and the kind decides the treatment: the
repository is the one catzc writes, a fact source is only read, and a state machine is reached by facts it then rules on.

---
catzc:
  config:
    pattern: image
    deck: product-thesis
    order: 3
---

# Writes its domain, reads fact sources, meets state machines

## Image

.assets/truth-stores.drawio.png

## Caption

Three kinds of truth store (TDR-STORES-THREESTOREKINDS): it writes its responsibility domain, the repository at one commit
(TDR-STORES-RESPONSIBILITYDOMAIN); reads a fact source and never writes it (TDR-STORES-FACTSOURCEREADONLY); and meets a state machine with
facts and takes its verdict (TDR-STORES-STATEMACHINE, TDR-STORES-RECONCILEFACTS).

## Notes

The scattered truth of the previous slide, sorted. Every store it touches is one of three kinds, and the kind decides the treatment: the
repository is the one it writes, a fact source is only read, and a state machine is reached by facts it then rules on.

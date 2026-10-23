---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-OUTFMT-VALIDATORISCODE
      - ADR-REPO-SLIDES-TWODIRECTIONS
---

# Every output format has a code validator and the diagram yml and png round trip

This article is one rule: [ADR-REPO-OUTFMT-VALIDATORISCODE](../../drs/repository/output-formats.md#rule-adr-repo-outfmt-validatoriscode) and
[ADR-REPO-SLIDES-TWODIRECTIONS](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-twodirections) merged into one. It holds
nothing beyond what those two rules say.

Every output format has a validator, and the validator is code: it checks structure, never taste, such as a file's signature and end marker,
an embedded model that decodes, pixel dimensions against the format's limits, required keys and the columns of a table. Two deterministic
directions join a diagram's declaration and its drawing: put renders the yml into the model embedded in the `.drawio.png`, and get reads the
embedded model back into the yml, so a hand edit in the editor is folded back.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-OUTFMT-VALIDATORISCODE
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---

# Every output format has a code validator and each formatter is configured

This article is one rule: [ADR-REPO-OUTFMT-VALIDATORISCODE](../../drs/repository/output-formats.md#rule-adr-repo-outfmt-validatoriscode) and
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters) merged into
one. It holds nothing beyond what those two rules say.

Every output format has a validator, and the validator is code: it checks structure, never taste, such as a file's signature and end marker,
pixel dimensions against the format's limits, required keys and the columns of a table. Each file language's formatter is configured, not
coded: its entry in `languages.yml` names the formatter engine, or states in `no_formatter:` why it has none.

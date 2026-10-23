---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FILEMETA-IMPRINTEDPARTS
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---

# The edges part is imprinted byte identically and each formatter is configured

This article is one rule: [ADR-REPO-FILEMETA-IMPRINTEDPARTS](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-imprintedparts) and
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters) merged into
one. It holds nothing beyond what those two rules say.

The `edges` part of a head is imprinted by `Format-FileMeta` and is byte-identical on every run: keys in the registry's order, values in
canonical form, no timestamp and no run identifier. Each file language's formatter is configured, not coded: its entry in `languages.yml`
names the formatter engine that formats its files, or states in `no_formatter:` why it has none.

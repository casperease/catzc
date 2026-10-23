---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-OUTDIR-DICTIONARIESGENERATED
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
---

# Spell checker dictionaries are generated and each formatter is configured

This article is one rule:
[ADR-REPO-OUTDIR-DICTIONARIESGENERATED](../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-dictionariesgenerated) and
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters) merged into
one. It holds nothing beyond what those two rules say.

The spell-checker dictionaries generated from the terminology registry are not committed: they are generated, one `<category>.txt` per
vocabulary category under the root `.cspell/`, gitignored and regenerated at the importer tail from `configs/terminology.yml`. Each file
language's formatter is configured the same way, not coded, in the file-language registry.

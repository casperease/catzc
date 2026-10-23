---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY
---

# Each formatter is configured and a code head holds two edges

This article is one rule:
[ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters) and
[ADR-REPO-CODEMETA-COMPUTABLEFACTSONLY](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-computablefactsonly) merged into one.
It holds nothing beyond what those two rules say.

Each file language's formatter is configured, not coded: its entry in `languages.yml` names the formatter engine, or states in
`no_formatter:` why it has none, and `Format-Code` runs the engines over every tracked file except vendored code. An authored code or config
file's head is the navigation head and holds exactly two edges under `edges`, `cites` and `docs`.

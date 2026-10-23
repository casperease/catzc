---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-MINIMAPSFROMDATA
      - ADR-REPO-DRSCODE-ONESTRINGONEFACT
---

# Minimaps are computed and every code names exactly one fact

This article is one rule:
[ADR-REPO-SLIDES-MINIMAPSFROMDATA](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-minimapsfromdata) and
[ADR-REPO-DRSCODE-ONESTRINGONEFACT](../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-onestringonefact) merged into one. It
holds nothing beyond what those two rules say.

A diagram shows exactly three minimaps, and a minimap's data is computed, never drawn by hand and never stored in the declaration. Codes
keep the same one-to-one discipline: under one parent a child ADR and a rule never share a segment, so every code names exactly one ADR,
rule or domain, and a retired name is never reused.

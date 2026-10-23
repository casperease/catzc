---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-DRSCODE-ONESTRINGONEFACT
      - ADR-REPO-FILEMETA-ROLE
---

# Every code names one fact and a files role is derived never written

This article is one rule:
[ADR-REPO-DRSCODE-ONESTRINGONEFACT](../../drs/repository/drs-code-language.md#rule-adr-repo-drscode-onestringonefact) and
[ADR-REPO-FILEMETA-ROLE](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-role) merged into one. It holds nothing beyond what those
two rules say.

Under one parent, a child ADR and a rule never share a segment, so every code names exactly one ADR, rule or domain; a retired name is never
reused and a rule whose meaning changes takes a new name. The role of a file, the part it plays such as a test, a function, a config or a
decision record, is derived on demand, never written into a head.

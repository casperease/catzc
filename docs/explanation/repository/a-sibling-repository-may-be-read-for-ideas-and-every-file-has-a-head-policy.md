---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-INSPIRE-SIBLINGFORIDEAS
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# A sibling repository may be read for ideas and every file has a head policy

This article is one rule: [ADR-REPO-INSPIRE-SIBLINGFORIDEAS](../../drs/repository/inspiration.md#rule-adr-repo-inspire-siblingforideas) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

A sibling repository of the same project family, such as `eac`, may be read for ideas on every aspect of catzc, from module and command
design to pipelines and tooling. It is read only: nothing is written to it, and when it is absent the work carries on without it. Files in
this repository are governed the other way round: every file on disk is format-managed, a `Format-*` command covers it and decides its head
policy.

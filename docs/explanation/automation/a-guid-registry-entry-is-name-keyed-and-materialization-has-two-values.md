---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GUIDS-NAMEKEYEDENTRY
      - ADR-AUTO-MATERIAL-MATERIALIZATION
---

# A guid registry entry is name keyed and materialization has two values

This article is one rule: [ADR-AUTO-GUIDS-NAMEKEYEDENTRY](../../drs/automation/managed-guids.md#rule-adr-auto-guids-namekeyedentry) and
[ADR-AUTO-MATERIAL-MATERIALIZATION](../../drs/automation/materialization.md#rule-adr-auto-material-materialization) merged into one. It
holds nothing beyond what those two rules say.

A GUID-registry entry is name-keyed and strict, `<snake_case_name>: { guid, description }`, with a canonical lowercase hyphenated GUID,
unique across entries, and unknown keys rejected. Materialization names when a knowledge resource comes into being and how long it holds: an
on-demand resource is made when asked and holds until the call ends, and a commit resource is made at commit.

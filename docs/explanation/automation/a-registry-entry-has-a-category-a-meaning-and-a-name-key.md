---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-SPELL-CATEGORYANDMEANING
      - ADR-AUTO-GUIDS-NAMEKEYEDENTRY
---

# A registry entry has a category a meaning and a name key (ADR-AUTO-SPELL-CATEGORYANDMEANING + ADR-AUTO-GUIDS-NAMEKEYEDENTRY)

This article is one rule:
[ADR-AUTO-SPELL-CATEGORYANDMEANING](../../drs/automation/spell-out-names.md#rule-adr-auto-spell-categoryandmeaning) and
[ADR-AUTO-GUIDS-NAMEKEYEDENTRY](../../drs/automation/managed-guids.md#rule-adr-auto-guids-namekeyedentry) merged into one. It holds nothing
beyond what those two rules say.

Registry entries are strict. Every spelling-registry entry is grouped under a category and declares a meaning; the `terms:` map groups
entries by category, so there is no per-entry category field. A GUID-registry entry is name-keyed,
`<snake_case_name>: { guid, description }`, with a canonical lowercase hyphenated GUID, unique across entries, and unknown keys are
rejected.

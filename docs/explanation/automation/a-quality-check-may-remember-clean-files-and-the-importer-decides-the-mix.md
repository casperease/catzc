---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS
      - ADR-AUTO-IMPORTER-DECIDESMIX
---

# A quality check may remember clean files and the importer decides the mix (ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS + ADR-AUTO-IMPORTER-DECIDESMIX)

This article is one rule:
[ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS](../../drs/automation/caching.md#rule-adr-auto-cache-checkedfilesacrosssessions) and
[ADR-AUTO-IMPORTER-DECIDESMIX](../../drs/automation/importer.md#rule-adr-auto-importer-decidesmix) merged into one. It holds nothing beyond
what those two rules say.

A quality check that runs an expensive tool over many files may keep, across sessions, which files the tool last found clean, keyed on each
file's SHA-256 together with a stamp of every input that decides the tool's verdict. What a session loads is decided by the importer, which
resolves each input in the one order of a setting: the caller's explicit value, else the importer's configuration, else the default.

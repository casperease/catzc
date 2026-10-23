---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-LANGUAGESFROMFILES
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# A modules languages come from its files and the build ships tracked files

This article is one rule: [ADR-AUTO-MODULE-LANGUAGESFROMFILES](../../drs/automation/module-model.md#rule-adr-auto-module-languagesfromfiles)
and [ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A module's languages are the file languages of its live files, and each must be one the track declares; a file in another language is a
stack violation. The build ships the files git tracks, and on a devbox the untracked files git does not ignore, and it is immutable and
content-addressed: the same commit yields a byte-identical build on any machine.

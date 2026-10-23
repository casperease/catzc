---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TRACKED-OTHERQUESTIONSTOGIT
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Git questions the index cannot answer stay with real git and builds ship tracked files (ADR-AUTO-TRACKED-OTHERQUESTIONSTOGIT + ADR-AUTO-BUNDLE-IMMUTABLEBUILD)

This article is one rule:
[ADR-AUTO-TRACKED-OTHERQUESTIONSTOGIT](../../drs/automation/tracked-files-from-the-index.md#rule-adr-auto-tracked-otherquestionstogit) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

Questions the index cannot answer stay with real git: which untracked files are not ignored, whether a path is ignored, and what
`.gitattributes` says about a path. They are real process launches. A build, by contrast, ships the files git tracks, and on a devbox the
untracked files git does not ignore, and it is immutable and content-addressed: the same commit yields a byte-identical build on any
machine.

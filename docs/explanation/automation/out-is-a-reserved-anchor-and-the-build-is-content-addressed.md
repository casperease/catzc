---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PATH-OUTANCHOR
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# Out is a reserved anchor and the build is content addressed

This article is one rule: [ADR-AUTO-PATH-OUTANCHOR](../../drs/automation/path-representation.md#rule-adr-auto-path-outanchor) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

`out/` is a reserved anchor, not an ordinary segment: a path under the output root takes the form `out/<remainder>`, and `Resolve-RepoPath`
re-anchors that `out/` sentinel against `Get-OutputRoot`, not the repository root. Builds land under it and are immutable and
content-addressed, the same commit yielding a byte-identical build on any machine.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ACCOSTED-COMMANDFORM
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# A command is written in contract form and the build is content addressed

This article is one rule: [ADR-AUTO-ACCOSTED-COMMANDFORM](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-commandform) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A command is written in the contract form: one mapping whose key is a contracted command's name in the repository normal form and whose
value maps each argument, by its normal-form parameter name, to a literal of the type the command contract gives it, for example
`get_file_language: { path: README.md }`. The build is immutable and content-addressed: the same commit yields a byte-identical build on any
machine.

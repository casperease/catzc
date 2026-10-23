---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ACCOSTED-FILEFORM
      - ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE
---

# An accosted file is a list of runs and every language track holds modules alike

This article is one rule: [ADR-AUTO-ACCOSTED-FILEFORM](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-fileform) and
[ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](../../drs/automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike) merged into
one. It holds nothing beyond what those two rules say.

An accosted file is `<name>.accosted.yml`: a YAML document whose one key, `runs:`, is a list of runs, each a list of commands run in order,
with no syntax of its own, no variables, pipes, branches, loops or output passed from one command to the next. Every language track holds
its modules the same way: a module is a non-dot folder directly under the track's root, named by the folder.

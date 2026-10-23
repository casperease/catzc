---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION
      - ADR-AUTO-MODULE-LANGUAGESFROMFILES
---

# A command is one public function and a modules languages come from its files

This article is one rule:
[ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](../../drs/automation/layers.md#rule-adr-auto-layers-commandispublicfunction) and
[ADR-AUTO-MODULE-LANGUAGESFROMFILES](../../drs/automation/module-model.md#rule-adr-auto-module-languagesfromfiles) merged into one. It holds
nothing beyond what those two rules say.

A command is one public function of the module system, the unit a contract describes, and it is written in one implementation language, a
file language of `languages.yml` whose entry sets `executable: true`, a flag that is false unless stated. A module's languages are the file
languages of its live files, and each must be one the track declares; a file in another language is a stack violation.

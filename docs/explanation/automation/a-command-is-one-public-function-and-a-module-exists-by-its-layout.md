---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
---

# A command is one public function and a module exists by its layout

This article is one rule:
[ADR-AUTO-LAYERS-COMMANDISPUBLICFUNCTION](../../drs/automation/layers.md#rule-adr-auto-layers-commandispublicfunction) and
[ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../drs/automation/module-model.md#rule-adr-auto-module-existsbylayout) merged into one. It holds nothing
beyond what those two rules say.

A command is one public function of the module system, the unit a contract describes, written in one implementation language. A module
exists when its files stand in its layout: nothing registers it and no descriptor file declares it. The layout is the one table of folders
inside a module and what each holds, public functions at the root, `private/`, `types/`, `configs/`, `assets/` and `tests/`.

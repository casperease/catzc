---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS
      - ADR-AUTO-ENGINE-STARTENVIRONMENT
---

# An unhandled language stops the import and black box tests start the engine by environment

This article is one rule:
[ADR-AUTO-IMPORTER-UNHANDLEDLANGUAGESTOPS](../../drs/automation/importer.md#rule-adr-auto-importer-unhandledlanguagestops) and
[ADR-AUTO-ENGINE-STARTENVIRONMENT](../../drs/automation/execution-engines.md#rule-adr-auto-engine-startenvironment) merged into one. It
holds nothing beyond what those two rules say.

A language the configuration names and the importer has no handler for stops the import with a NotImplemented error that names the language.
A black-box test in another language starts the engine from the engine start environment its runner sets, `CATZC_ENGINE`,
`CATZC_ENGINE_EXECUTABLE`, `CATZC_ENGINE_ENTRY` and `CATZC_ENGINE_START`, never from a hardcoded command.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-PWSH-ONEFUNC-GOVERNSSOURCE
---

# A setting resolves in one fixed order and source is the one function files

This article is one rule:
[ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder) and
[ADR-PWSH-ONEFUNC-GOVERNSSOURCE](../../drs/automation/pwsh/one-function-per-file.md#rule-adr-pwsh-onefunc-governssource) merged into one. It
holds nothing beyond what those two rules say.

A configurable setting resolves in one fixed order: the caller's explicit value, else the value in the owning module's configuration
(`Get-Config`), which includes the config contributions gathered from Markdown files. The rule for one function per file governs source
under `pwsh/<Module>/`; the installed build's merged `<Module>.functions.ps1` is a generated artifact of `Build-Modules`.

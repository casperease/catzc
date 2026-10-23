---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-NAMESPACEISTRACK
      - ADR-AUTO-OVERLAY-LOCALMODULE
---

# A modules namespace is its track and a local module follows the conventions

This article is one rule: [ADR-AUTO-MODULE-NAMESPACEISTRACK](../../drs/automation/module-model.md#rule-adr-auto-module-namespaceistrack) and
[ADR-AUTO-OVERLAY-LOCALMODULE](../../drs/automation/consumer-overlay.md#rule-adr-auto-overlay-localmodule) merged into one. It holds nothing
beyond what those two rules say.

A module's namespace is the name of the track that holds it, derived from placement and never written into the module's name. A local module
is a folder under `.catzc/pwsh/` that names no bundled module: the consumer's own module, following catzc's module conventions, folder
equals module, a public function per root function file and private function files under `private/`.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
      - ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL
---

# A module exists by layout and an install is two artifacts in two places

This article is one rule: [ADR-AUTO-MODULE-EXISTSBYLAYOUT](../../drs/automation/module-model.md#rule-adr-auto-module-existsbylayout) and
[ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-twoartifactinstall) merged into one. It
holds nothing beyond what those two rules say.

A module exists when its files stand in its layout; nothing registers it, and no descriptor file declares it. An install is two artifacts in
two places: `Export-Catzc -Root <dir>` copies the build to `<dir>/.vendor/Catzc/<version>/` and writes a root importer entry at the
destination root that loads the installed build's entry with `<dir>` as the working root.

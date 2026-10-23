---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-REMOVE-OFFCONFIGTOOLSONLY
      - ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL
---

# Remove exists only for off config tools and an install is two artifacts

This article is one rule:
[ADR-AUTO-REMOVE-OFFCONFIGTOOLSONLY](../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-offconfigtoolsonly) and
[ADR-AUTO-BUNDLE-TWOARTIFACTINSTALL](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-twoartifactinstall) merged into one. It
holds nothing beyond what those two rules say.

`Remove-<Tool>` exists only for tools that are historically installed off-config, a distro package, a `pip install`, an OS stub or a
hand-built binary, that would shadow the managed build; it is added where an eviction hole exists. An install is two artifacts in two
places: `Export-Catzc -Root <dir>` copies the build to `<dir>/.vendor/Catzc/<version>/` and writes a root importer entry at the destination
root.

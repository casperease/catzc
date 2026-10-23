---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-REMOVE-THREEPLATFORMCORES
      - ADR-AUTO-DEPS-PLATFORMPREREQUISITEASSERTED
---

# Three platform cores carry removal and platform prerequisites are asserted never installed (ADR-AUTO-REMOVE-THREEPLATFORMCORES + ADR-AUTO-DEPS-PLATFORMPREREQUISITEASSERTED)

This article is one rule:
[ADR-AUTO-REMOVE-THREEPLATFORMCORES](../../drs/automation/tool-removal-lifecycle.md#rule-adr-auto-remove-threeplatformcores) and
[ADR-AUTO-DEPS-PLATFORMPREREQUISITEASSERTED](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-platformprerequisiteasserted)
merged into one. It holds nothing beyond what those two rules say.

Three platform cores carry the destructive mechanics and `Remove-<Tool>` delegates to the one for the running OS:
`Remove-SystemInstallation` on Windows, `Remove-LinuxToolInstall` on Linux and a macOS counterpart. A platform-provided prerequisite, such
as winget, `/bin/bash` on Linux or git with Git Bash on a devbox, is asserted, never installed by its own entry.

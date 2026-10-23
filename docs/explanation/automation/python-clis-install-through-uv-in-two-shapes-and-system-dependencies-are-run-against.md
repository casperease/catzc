---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-UVPY-TWOINSTALLSHAPES
      - ADR-AUTO-DEPS-TWODEPENDENCYKINDS
---

# Python clis install through uv in two shapes and system dependencies are run against

This article is one rule: [ADR-AUTO-UVPY-TWOINSTALLSHAPES](../../drs/automation/uv-python-handler.md#rule-adr-auto-uvpy-twoinstallshapes)
and [ADR-AUTO-DEPS-TWODEPENDENCYKINDS](../../drs/automation/controlling-systemwide-deps.md#rule-adr-auto-deps-twodependencykinds) merged
into one. It holds nothing beyond what those two rules say.

A Python-based CLI installs through uv in one of two shapes declared in `tools.yml`: a standalone CLI such as Azure CLI or Poetry installs
as an isolated tool, so its dependency graph never touches any other environment, while a package that must stay importable, PySpark,
installs into a shared environment. These are system dependencies, external runtimes or CLIs the automation runs against and installed at
the OS level, covered by the Tooling layer.

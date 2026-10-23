---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-UVPY-TWOINSTALLSHAPES
      - ADR-AUTO-PY-GENERATEDWORKSPACE
---

# Python clis install through uv in two shapes and the python tests form one workspace

This article is one rule: [ADR-AUTO-UVPY-TWOINSTALLSHAPES](../../drs/automation/uv-python-handler.md#rule-adr-auto-uvpy-twoinstallshapes)
and [ADR-AUTO-PY-GENERATEDWORKSPACE](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-generatedworkspace) merged into
one. It holds nothing beyond what those two rules say.

A Python-based CLI installs through uv in one of two shapes declared in `tools.yml`: a standalone CLI such as Azure CLI or Poetry as an
isolated tool, so its dependency graph never touches any other environment, or, for a package that must stay importable such as PySpark,
into a shared environment. The Python tests form one generated, gitignored uv workspace, with nothing Python-specific committed but the
`test_*.py` files.

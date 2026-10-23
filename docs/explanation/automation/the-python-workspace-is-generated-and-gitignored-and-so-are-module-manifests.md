---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PY-GENERATEDWORKSPACE
      - ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED
---

# The python workspace is generated and gitignored and so are module manifests

This article is one rule:
[ADR-AUTO-PY-GENERATEDWORKSPACE](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-generatedworkspace) and
[ADR-PWSH-MANIFEST-MANIFESTSGITIGNORED](../../drs/automation/pwsh/dynamic-module-manifests.md#rule-adr-pwsh-manifest-manifestsgitignored)
merged into one. It holds nothing beyond what those two rules say.

The Python tests form one generated, gitignored uv workspace: nothing Python-specific is committed but the `test_*.py` files, and
`New-PythonProject` renders the workspace root `<root>/pyproject.toml`. Generated manifests are gitignored in the same way, never committed:
`New-DynamicManifest` recomputes each module's `<Module>.psd1` on every import, writing only when the content differs.

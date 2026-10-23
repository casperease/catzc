---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-BCL-TYPES-DEBUGANYCPU
      - ADR-AUTO-PY-ONEPYTHONROOT
---

# Builds use debug on any cpu and the python tests live under one python root

This article is one rule: [ADR-BCL-TYPES-DEBUGANYCPU](../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-debuganycpu) and
[ADR-AUTO-PY-ONEPYTHONROOT](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-onepythonroot) merged into one. It holds
nothing beyond what those two rules say.

Every non-vendored `.sln` and `.csproj` declares exactly one build configuration and platform, Debug on Any CPU, and every `dotnet` call a
catzc command makes builds that pair. The Python tests live under one Python root, a repository-relative folder declared by `python.yml`'s
`root`, `python` when the repository has a `python/` folder, else the dot-prefixed `.python`.

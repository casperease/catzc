---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-LAYERS-REALISENEVERREDEFINE
      - ADR-AUTO-PY-MODULESBYLAYOUT
---

# Each layer realises the one above and python is a track module never the engine (ADR-AUTO-LAYERS-REALISENEVERREDEFINE + ADR-AUTO-PY-MODULESBYLAYOUT)

This article is one rule: [ADR-AUTO-LAYERS-REALISENEVERREDEFINE](../../drs/automation/layers.md#rule-adr-auto-layers-realiseneverredefine)
and [ADR-AUTO-PY-MODULESBYLAYOUT](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-modulesbylayout) merged into one. It
holds nothing beyond what those two rules say.

Each layer realises the one above it and never redefines it: automation, contract, language, engine, importer, read top down as what, its
interface, how it is written, how it runs, how it is assembled. Python code sits inside that order as a module of the `python` track or as a
black-box test under the track's test holder. A Python module ships only what `files.yml` packages and a test file never ships. No function
of the engine is written in Python; the engine is PowerShell and C#, and a Python module is a tool the engine runs as a process.

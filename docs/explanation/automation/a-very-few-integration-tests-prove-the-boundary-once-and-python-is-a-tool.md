---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-FEWINTEGRATIONTESTS
      - ADR-AUTO-PY-MODULESBYLAYOUT
---

# A very few integration tests prove the boundary once and python is a tool (ADR-AUTO-TEST-FEWINTEGRATIONTESTS + ADR-AUTO-PY-MODULESBYLAYOUT)

This article is one rule:
[ADR-AUTO-TEST-FEWINTEGRATIONTESTS](../../drs/automation/test-automation.md#rule-adr-auto-test-fewintegrationtests) and
[ADR-AUTO-PY-MODULESBYLAYOUT](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-modulesbylayout) merged into one. It
holds nothing beyond what those two rules say.

Keep a very few integration tests, one per distinct integration concern, never one per input case: pick the broadest single thread that
exercises the wiring, prove the boundary connects once, and let input variations live at L0. The same economy governs Python: it is a module
of the `python` track or a black-box test under the track's holder, no function of the engine is written in it, and a Python module is a
tool, such as the diagram renderer, that the engine runs as a process.

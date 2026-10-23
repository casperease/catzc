---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-PY-EVERYFILELINTED
      - ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE
---

# Every python file is linted and every language track holds modules alike

This article is one rule:
[ADR-AUTO-PY-EVERYFILELINTED](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfilelinted) and
[ADR-AUTO-MODULE-EVERYLANGUAGETRACKALIKE](../../drs/automation/module-model.md#rule-adr-auto-module-everylanguagetrackalike) merged into
one. It holds nothing beyond what those two rules say.

Every `.py` file the repository holds takes the repository's checks where a check reads Python, with the pinned ruff and the workspace's
settings. Every language track holds its modules the same way: a module is a non-dot folder directly under the track's root, named by the
folder, with pwsh one language among the others.

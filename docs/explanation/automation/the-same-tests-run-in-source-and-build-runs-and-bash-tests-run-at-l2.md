---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BASH-LANGUAGEBRIDGE
      - ADR-AUTO-TEST-SAMETESTSBOTHRUNS
---

# The same tests run in source and build runs and bash tests run at l2 (ADR-AUTO-BASH-LANGUAGEBRIDGE + ADR-AUTO-TEST-SAMETESTSBOTHRUNS)

This article is one rule: [ADR-AUTO-BASH-LANGUAGEBRIDGE](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-languagebridge)
and [ADR-AUTO-TEST-SAMETESTSBOTHRUNS](../../drs/automation/test-automation.md#rule-adr-auto-test-sametestsbothruns) merged into one. It
holds nothing beyond what those two rules say.

The same tests run in two kinds of test run, one per run mode: the source run (`Test-Automation`) loads the modules from the code root
through the source entry script, and the build run (`Test-CatzcBuild`) builds the selected modules and loads them through the build's entry
script. Bash tests join them through the language bridge the Go and Python tests use: discovery maps each Bash test folder to its catzc
module and the bridge turns every `@test` into one test, tagged `L2`.

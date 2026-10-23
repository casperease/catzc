---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BASH-LANGUAGEBRIDGE
      - ADR-AUTO-TEST-LANGUAGETESTMODULES
---

# Bash tests run through the language bridge and test modules come in a second kind

This article is one rule: [ADR-AUTO-BASH-LANGUAGEBRIDGE](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-languagebridge)
and [ADR-AUTO-TEST-LANGUAGETESTMODULES](../../drs/automation/test-automation.md#rule-adr-auto-test-languagetestmodules) merged into one. It
holds nothing beyond what those two rules say.

`Test-Automation` runs the Bash tests through the language bridge the Go and Python tests run through: discovery maps each Bash test folder
to its catzc module, and the bridge turns every `@test` into one test of the run, tagged `L2`. A Go test module, a Python test folder and a
Bash test folder are the second kind of test module, beside a module's own tests.

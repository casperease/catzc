---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BASH-ONEBASHROOT
      - ADR-AUTO-TEST-LANGUAGETESTMODULES
---

# Bash tests live under one bash root and test modules are the second kind

This article is one rule: [ADR-AUTO-BASH-ONEBASHROOT](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot) and
[ADR-AUTO-TEST-LANGUAGETESTMODULES](../../drs/automation/test-automation.md#rule-adr-auto-test-languagetestmodules) merged into one. It
holds nothing beyond what those two rules say.

The Bash tests live under one Bash root, a repository-relative folder declared by `bash.yml`'s `root`, `bash` when the repository has a
`bash/` folder, else the dot-prefixed `.bash`; a Bash test folder is the folder `<root>/tests/<module>/`. A Go test module, a Python test
folder and a Bash test folder are the second kind of test module.

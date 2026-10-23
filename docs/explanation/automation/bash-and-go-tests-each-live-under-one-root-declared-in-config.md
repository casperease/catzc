---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-BASH-ONEBASHROOT
      - ADR-AUTO-GO-ONEGOROOT
---

# Bash and go tests each live under one root declared in config

This article is one rule: [ADR-AUTO-BASH-ONEBASHROOT](../../drs/automation/bash/bash-test-artifacts.md#rule-adr-auto-bash-onebashroot) and
[ADR-AUTO-GO-ONEGOROOT](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-onegoroot) merged into one. It holds nothing beyond
what those two rules say.

The Bash tests live under one Bash root, declared by `bash.yml`'s `root`, `bash` when the repository has a `bash/` folder, else `.bash`, and
the Go tests live under one Go root declared by `go.yml`'s `root`, `go` when the repository has a `go/` folder, else `.go`. In both, a test
folder or module is `<root>/tests/<module>/`, one per catzc module.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-GO-GOCHECKS
      - ADR-AUTO-PY-EVERYFILELINTED
---

# Go and python files take their languages checks in the repository

This article is one rule: [ADR-AUTO-GO-GOCHECKS](../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gochecks) and
[ADR-AUTO-PY-EVERYFILELINTED](../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfilelinted) merged into one. It
holds nothing beyond what those two rules say.

Go code takes the repository's checks where a check reads Go: `gofmt` through `Test-Formatting`, `go vet` before every Go test run, and the
spelling check over `*.go`. Every `.py` file takes the repository's checks where a check reads Python, with the pinned ruff and the
workspace's settings: `ruff format` through `Test-Formatting` and `ruff check` through the Python lint gate.

---
catzc:
  derived:
    path: docs/how-to/getting-started/automation/go/index.md
    kind: how-to
    body_sha: "03642fb25d9b"
    adrs: []
    links:
      - docs/adr/automation/go/go-test-artifacts.md
---

# Go how-to guides

Go in catzc is test artifacts only: black-box tests under the Go root's `tests/<module>/` folders, run through `Test-Automation`. The
decision record is [ADR-AUTO-GO](../../../../adr/automation/go/go-test-artifacts.md).

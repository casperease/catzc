---
catzc:
  derived:
    path: docs/adr/automation/bash/index.md
    kind: adr
    body_sha: "22ad4883d6b9"
    links:
      - docs/adr/automation/bash/bash-test-artifacts.md
      - docs/adr/automation/execution-engines.md
---

# Bash automation ADRs

The ADRs here govern the repository's Bash code, which is test artifacts only — black-box tests of the engine that reach catzc through the
`cats` dispatcher and never ship; see [bash-test-artifacts](bash-test-artifacts.md). bash as one of the three execution engines is governed
one level up, by [execution-engines](../execution-engines.md). Cross-cutting, language-agnostic platform rules live directly under
`automation/`; the full code↔ADR registry is the ADR index at the root of `docs/adr/`.

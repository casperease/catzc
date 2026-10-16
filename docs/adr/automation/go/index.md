---
catzc:
  derived:
    path: docs/adr/automation/go/index.md
    folder: docs/adr/automation/go
    name: index
    filetype: md
    kind: adr
    language: markdown
    track: docs
    body_sha: "57d973bedb2e"
    links:
      - docs/adr/automation/go/go-test-artifacts.md
---

# Go automation ADRs

The ADRs here govern the repository's Go code, which is test artifacts only — black-box tests of the engine that never ship; see
[go-test-artifacts](go-test-artifacts.md). Cross-cutting, language-agnostic platform rules live one level up, directly under `automation/`;
the full code↔ADR registry is the ADR index at the root of `docs/adr/`.

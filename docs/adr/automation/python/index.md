---
catzc:
  immutable:
    with_body_sha: daf24257c517
    repo_status: clean
    path: docs/adr/automation/python/index.md
    folder: docs/adr/automation/python
    name: index
    filetype: md
    kind: adr
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/adr/automation/python/python-test-artifacts.md
      - docs/adr/automation/uv-python-handler.md
---

# Python automation ADRs

The ADRs here govern the repository's Python code, which is test artifacts only — black-box tests of the engine that never ship; see
[python-test-artifacts](python-test-artifacts.md). The Python-based tools the devbox installs are governed one level up, by
[uv-python-handler](../uv-python-handler.md). Cross-cutting, language-agnostic platform rules live directly under `automation/`; the full
code↔ADR registry is the ADR index at the root of `docs/adr/`.

---
catzc:
  derived:
    path: docs/adr/pwsh/index.md
    kind: adr
    language: markdown
    track: docs
    body_sha: e7e62cc95be3
    links:
      - docs/adr/automation/execution-engines.md
      - docs/adr/index.md
      - docs/adr/pwsh/pwsh-engine.md
---

# PowerShell engine ADRs

The ADRs here govern PowerShell 7 as one of catzc's execution engines ([execution-engines](../automation/execution-engines.md)): how the
engine-agnostic rules of `automation/` are realised in pwsh, and the rules that only mean something in pwsh — module files and manifests,
the session the importer sets up, parameters, errors and streams, caching in script scope, working-directory and environment mechanics,
cross-platform pwsh, the analyzer, and Pester. The domain's anchor is [pwsh-engine](pwsh-engine.md). A rule here applies an `automation/`
rule to one engine and cites it; it never redefines it. The full code↔ADR registry is the [ADR index](../index.md).

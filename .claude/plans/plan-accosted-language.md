---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets: [pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml]
---

# Accosted language

**accosted** is the cats language of `<name>.accosted.yml` run lists (ADR-AUTO-ACCOSTED): runs of harmless contracted commands in the
contract form, run under every engine by `Invoke-Accosted`. The language, its reader, runner, contracts and the first run list are in the
tree; the one thing left is the proof under the engine this devbox lacks.

## Why its value is medium

It proves every harmless contracted command answers from every engine, in the notation the contracts already use. Nothing breaks without the
last engine's proof, so medium.

## Open steps

- [ ] zsh: with zsh installed (its `tools.yml` entry), run
      `Invoke-Accosted -Path pwsh/Catzc.Base.Contracts/accosted/contracts.accosted.yml -Engine zsh` (check: every run Passed; pwsh and bash
      already pass 4 of 4).

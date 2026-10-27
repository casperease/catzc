---
plan:
  status: active
  value: high
  reviewed: 2026-10-27
  class: meta
  targets: [docs/drs]
---

# DRS simplification: contradictions settled, tiers clean, one rule per point

The records are strong but have grown. The in-place prose pass landed (57 records tightened, no code, heading or anchor changed); this plan
holds what that pass could not do in place: contradictions, content a tier too high, rules that state one thing, and sections that only
restate their rules. Every step keeps each decision and its rationale; a merged rule's code is retired and every citation re-cited in the
same change (`Update-AdrCitation`, PDR-ONELIVE). The check "the record check" means `Test-DrsRegistry` and `Test-Links` on the touched
records.

## Open steps

### Verify the last wave

The flow, ado and azure merges, the session-rule rename (ADR-AZ-SESSION-SEPARATECONCERNS), the BCL host rules, the folder and config
samples, the value-chain move (ADR-REPO-VALUECHAIN), ONETRACKTYPE, the arrows rule and the pewter tint rename landed with a 226-change
re-cite; five importer-path files went by staged burst, its 14 test files green.

- [ ] `Build-DrsIndex` and `Build-Glossary`, then the record check over the tree plus `Test-Spelling`, `Test-Glossary` and
      `Test-DrsEngineNeutrality`. Check: each reports 0 issues.
- [ ] The glossary sources' "cell" and "lit cell" (`pwsh/Base.ModuleSystem/configs/glossary.yml`) read the world map only, since their
      defining design rules no longer carry the value-chain half. Check: `Test-Glossary`.

### Sections that restate their rules

- [ ] `repository/conventional-folders.md`: "How this is enforced" becomes one current list. Check: the record check.
- [ ] `repository/api-contracts.md`: "The name picks the kind", the Decision restatement and "Three version ranges" go; rejected
      alternatives 1/3/10 and 2/7 fold together; HEADPOLICY's carrier detail in `repository/file-meta.md` defers to JSONCARRIER. Check: the
      record check.

### Records still owed a full prose pass

- [ ] The same in-place tightening for `repository/` (slides-as-markdown, command-contracts, drs-code-language, uniform-formatting,
      controlled-vocabulary, markdown-links, agent-definitions and the rest), the Context bodies of the larger `automation/` records
      (platform-bundle, console-output-matters, path-representation, fail-fast-with-asserts, environment-variables, caching, module-model)
      and ~25 smaller ones, and `automation/pwsh/` (dynamic-module-manifests, environment-variable-mechanics, pwsh-engine, error-handling,
      powershell-formatting and the rest). Check: the record check.

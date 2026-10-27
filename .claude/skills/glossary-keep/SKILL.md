---
name: glossary-keep
description: >
  Keep the glossary sources in step with the rules for a named term or file set, one term per step; never rewrites the prose a term appears
  in, never decides what a term means; input is the terms or files.
user-invocable: false
allowed-tools: Bash, Read, Grep, Edit
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: [pwsh]
---

# glossary-keep

Keep the glossary sources in step with the rules, one term per step; the page is generated, never edited.

1. `Test-Glossary` through `catzc-gate`; keep the issues that name the brief's terms or files.
2. For each term: find the one rule that bolds it (drs-cite), then in that module's `configs/glossary.yml` the entry is the term as key,
   `key` its snake_case id, `domain`, `defined_by` the rule code, a `short` of one sentence; a term with no bolding rule is reported, never
   invented; a YAML flow value that holds a comma is quoted (an unquoted one broke every import on 2026-10-21).
3. After each entry, `Build-Glossary` then `Test-Glossary` again through `catzc-gate`.
4. Report the terms added or corrected with their defining rule, the collisions found, and the terms left for the user.

---
name: adr-cite
description:
  How to find the rules that govern a set of files and cite them by code without sweeping the corpus; for adr-reviewer and glossary-keeper;
  input is the list of files under review.
user-invocable: false
allowed-tools: Read, Grep, Glob
paths: docs/adr/**
metadata:
  catzc:
    immutable:
      repo_status: clean
      path: ".claude/skills/adr-cite/SKILL.md"
      folder: skills/adr-cite
      name: skill
      filetype: md
      kind: capability
      language: markdown
      track: ".claude"
      tracktype: vendor-settings
      vendor: claude
      module: ".claude"
      moduletype: settings
    config:
      model_floor: haiku
      needs: []
---

# adr-cite

1. Read `docs/adr/index.md` first; it maps every code to its ADR and domain; never read the whole corpus and never `docs/adr/research/`.
2. For each file under review take the codes its head `edges.cites` names and the domain its track implies, then read those ADRs in full,
   their `## Rules` section first.
3. Cite a rule as `ADR-X#n` only, the code and number of a `### Rule ADR-X:n` heading actually read; a finding without a rule it rests on is
   not a finding.

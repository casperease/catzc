---
name: drs-cite
description:
  How to find the rules that govern a set of files and cite them by code without sweeping the DRS; for drs-reviewer and glossary-keeper;
  input is the list of files under review.
user-invocable: false
allowed-tools: Read, Grep, Glob
paths: docs/drs/**
metadata:
  catzc:
    config:
      model_floor: haiku
      needs: []
---

# drs-cite

1. Read `docs/drs/index.md` first; it maps every code to its decision record and domain; never read the whole DRS and never
   `docs/drs/research/`.
2. For each file under review take the codes its head `edges.cites` names and the domain its track implies, then read those decision
   records in full, their `## Rules` section first.
3. Cite a rule by the full code of a `### Rule` heading actually read; a finding without a rule it rests on is not a finding, and a "never"
   or "only" rule is searched against the commands that do the thing before it is reported clean; a domain cites only the domains its
   `adrs.yml` entry lists in `depends_on`, and any other citation fails `Test-AdrRegistry`.

---
plan:
  status: active
  value: high
  reviewed: 2026-10-20
  waits_on: nothing; both steps are takeable
  targets: [docs/adr, pwsh/Catzc.Base.Docs]
---

# ADR citations follow the domain dependencies, in the body too

An ADR cites only the domains its domain's `depends_on` in `adrs.yml` names; anything else is said with the glossary term. The guard checks
summary lines only, so body citations against the direction slip through (found by catzc-c0 on 2026-10-20 during the ADR-FLOW-CD-LIFE
move): `design/server-remote-integration.md` cites ADR-FLOW-CD in Related, and process and research pages cite design codes.

## Why its value is high

A citation against the dependency direction makes a cycle between domains, so a domain can no longer be read, reviewed or moved without the
one it should sit under.

## Open steps

- [ ] The ADR registry check holds every citation in an ADR page, not only the summary line, against its domain's `depends_on`, and names
      the file, the line and the domain it may not cite (check: the check's test file, with one fixture page citing a forbidden domain in
      its body, fails with that line; one citing an allowed domain passes).
- [ ] Every finding the extended check reports is reworded by hand to the glossary term, one file at a time, with no code and no link into
      the forbidden domain (check: Test-AdrRegistry clean; Test-Links and Test-Glossary clean on each touched file).

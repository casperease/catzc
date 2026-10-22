---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs, pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1]
---

# Debt glossary rule code: a two-segment ADR code passes as a glossary entry's defining rule

`GlossaryConfig.Tests.ps1:147-153` ("accepts a named rule citation, the domain, the ADR and the rule's name") is red: it expects
`defined_by: ADR-COG-GADGET` to throw "must be a rule's code", because two segments name an ADR, not a rule, but no exception is thrown
(catzc-e3, 2026-10-22, in the fresh import after the DefaultExclude change; the excludes cases of the same file pass). The check lives in
the `defined_by` parse of `GlossaryConcept.cs`, likely loosened by the named-rule code change. The chunk owns those two files.

## Open steps

1. [ ] `pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs`: find why `defined_by` accepts a two-segment ADR code, and reject it with "must be a
       rule's code" (ADR-REPO-DRSCODE-NAMEDNOTNUMBERED), or, when the rule now allows an ADR code, change the test case with the rule cited.
       C# type edit on the import path: a HOLD to every live peer first. Check: `Invoke-TestFile` on
       `pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1`, and `Test-Glossary` reports 0 issues.

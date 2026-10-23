---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-PROVENANCETAGS
      - ADR-PWSH-PESTER-DISCOVERYONLYPASS
---

# A test may carry provenance tags and a discovery only pass reads them

This article is one rule: [ADR-AUTO-TEST-PROVENANCETAGS](../../drs/automation/test-automation.md#rule-adr-auto-test-provenancetags) and
[ADR-PWSH-PESTER-DISCOVERYONLYPASS](../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-discoveryonlypass) merged into one. It
holds nothing beyond what those two rules say.

An optional third, provenance dimension: a test may carry `ADR-<CODE>#<n>` citation tags naming the DRS rule or rules it enforces, so the
`ADR-` marker greps to both a rule's prose and its enforcing tests; absence is never a violation, and a present citation is validated. The
discovery-only pass is a Pester run with `Run.SkipRun` set, so `Get-TestTagViolations` reads the tags from the discovered tree without
running a body.

---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-TEST-ONEIMPORTPERCASE
      - ADR-PWSH-PESTER-CHILDPROCESSPERCASE
---

# One import per distinct tree shape is spawned and asserted across it blocks

This article is one rule: [ADR-AUTO-TEST-ONEIMPORTPERCASE](../../drs/automation/test-automation.md#rule-adr-auto-test-oneimportpercase) and
[ADR-PWSH-PESTER-CHILDPROCESSPERCASE](../../drs/automation/pwsh/pester-testing.md#rule-adr-pwsh-pester-childprocesspercase) merged into one.
It holds nothing beyond what those two rules say.

When the unit is a pure function of the filesystem, spawn one import per distinct tree shape, not per assertion: capture a rich observation
from a single import and assert it across separate tests, minimising the spawn count. In Pester this means one child `pwsh` import per
distinct tree shape in `BeforeAll`, a captured JSON observation, and assertions across separate `It` blocks.

# pwsh/Base.QualityGates/private/Get-TestTagViolations.ps1

Lists every Pester test that is missing a required tag axis, or ambiguous on one.

## help

### synopsis

Lists every Pester test that is missing — or ambiguous on — a required tag axis.

### description

Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run level or tag filters, and resolves
each test's tier (L0-L4) and category (logic|integrity) via Get-TestBlockTag (nearest contributing block wins). A test is a violation when
an axis resolves to zero tags (missing) or to more than one on its nearest contributing block (ambiguous).

It also validates the optional provenance axis — the '`ADR-<CODE>#<n>`' rule citations a test may carry to say which rule(s) it enforces.
Absence is never a violation (the axis is optional), but a PRESENT citation must be well-formed and resolve to a real rule: any tag carrying
the reserved rule-code marker that is not a well-formed '`ADR-<CODE>#<n>`', or that names a rule absent from Get-DrsRuleIds, is a violation.
The rule-id set is resolved lazily (only when a well-formed citation is present), so tests with no citation stay hermetic — they never read
the shipped DRS tree.

Returns one object per violating test: @{ Test; File; Reason }. Test-Automation calls this to enforce that every test carries exactly one
tier and one category tag, and that any rule citation it carries is real. See the test-automation record.

### parameter `Discovery`

The discovery-only Pester run object (Get-TestDiscovery output) whose tests are inspected.

## Rule ids

The authoritative rule-id set is resolved once, on the first well-formed citation, and reused across tests; Get-DrsRuleIds is itself
session-cached. Until then the set stays `$null`, so a run whose tests carry no citation never reads the shipped DRS tree, which keeps these
logic tests hermetic. The ids are in registry form, with a colon.

## Provenance axis

The provenance axis is optional. Every candidate citation, meaning any tag carrying the reserved rule-code marker, is collected across the
block chain (the test's own tags plus its ancestor blocks, root excluded), and each is then classified. A malformed candidate never needs
the rule-id set, and a well-formed one triggers its lazy resolution.

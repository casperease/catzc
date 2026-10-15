# docs/references/automation/catzc-base-qualitygates/private/Get-TestTagViolations.ps1.md

`automation/Catzc.Base.QualityGates/private/Get-TestTagViolations.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Inspects a discovery-only Pester result (Get-TestDiscovery), so EVERY test is checked regardless of run
level or tag filters, and resolves each test's tier (L0-L4) and category (logic|integrity) via
Get-TestBlockTag (nearest contributing block wins). A test is a violation when an axis resolves to zero
tags (missing) or to more than one on its nearest contributing block (ambiguous).

It also validates the optional provenance axis — the 'ADR-<CODE>#<n>' rule citations a test may carry to
say which ADR rule(s) it enforces. Absence is never a violation (the axis is optional), but a PRESENT
citation must be well-formed and resolve to a real rule: any tag carrying the reserved 'ADR-' marker that
is not a well-formed 'ADR-<CODE>#<n>', or that names a rule absent from Get-CatsAdrRuleIds, is a violation.
The rule-id set is resolved lazily (only when a well-formed citation is present), so tests with no
citation stay hermetic — they never read the shipped ADR tree.

Returns one object per violating test: @{ Test; File; Reason }. Test-Automation calls this to enforce that
every test carries exactly one tier and one category tag, and that any rule citation it carries is real.
See the test-automation ADR.
```

## comment:2

Above `$validRuleIds = $null`.

```text
The authoritative rule-id set, resolved once on the first well-formed citation and reused across tests
(Get-CatsAdrRuleIds is itself session-cached). Left $null until then so a run whose tests carry no
citation never reads the shipped ADR tree — keeping these logic tests hermetic. Registry (':') form.
```

## comment:3

Above `$candidates =...`.

```text
Provenance axis (optional): collect every candidate citation — any tag carrying the reserved 'ADR-'
marker — across the block chain (own It-tags + ancestor blocks, root excluded), then classify each.
A malformed candidate never needs the rule-id set; a well-formed one triggers its lazy resolution.
```

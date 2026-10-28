# pwsh/Base.QualityGates/private/Select-RuleTaggedFiles.ps1

Returns the subset of test files that carry a test citing one of the given rules. It is the work-list filter behind Test-Automation's
`-Rule` parameter, which narrows a run to the files that enforce a rule.

## help

### synopsis

The subset of test files that carry a test citing one of the given rules — the -Rule work-list filter.

### description

Test-Automation's `-Rule` provenance filter narrows the run to the files that actually enforce a rule. Given the discovery pass (all tests,
any tier) and the wanted citations, this returns the files in which at least one test resolves one of those citations (Get-TestRuleTags, the
same union used for coverage). The worker additionally filters within a file by include tag, so a file mixing matched and other tests runs
only the matched ones; this just keeps whole non-matching files off the work-list.

### parameter `TestFile`

The candidate test files (absolute `*.Tests.ps1` paths), in run order.

### parameter `Discovery`

The discovery-only Pester run object whose tests carry the citation tags.

### parameter `Rule`

The wanted citations in '`ADR-<CODE>#<n>`' form. A file is kept when one of its tests cites any of them.

### outputs

`[string[]]` the kept files, preserving the input order (empty when none match).

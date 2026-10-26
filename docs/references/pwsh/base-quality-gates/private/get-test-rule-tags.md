# pwsh/Base.QualityGates/private/Get-TestRuleTags.ps1

Returns the set of ADR rule citations a Pester test enforces: every `ADR-<CODE>#<n>` tag on the test and its ancestor blocks, unioned.

## help

### synopsis

The set of ADR rule citations a Pester test enforces — every '`ADR-<CODE>#<n>`' tag on the test and its ancestor blocks, unioned.

### description

The optional third tag dimension (provenance): which ADR rule(s) a test enforces, cited in the [index](../../../../drs/index.md) '#' form
(e.g. 'ADR-PWSH-ERROR-THROWNOTWRITEERROR'). Unlike the tier and category axes — single-valued and resolved nearest-contributing-block-wins
(Get-TestBlockTag) — provenance is SET-VALUED and ADDITIVE: a Describe may enforce a broad rule and an inner It a specific one, and both
hold. So this UNIONS every well-formed citation across the test's own It-tags and every ancestor block (root excluded), returning them
distinct and sorted. Only strictly well-formed '`ADR-<CODE>#<n>`' citations contribute; a malformed one is left for Get-TestTagViolations to
reject rather than silently entering a coverage row. See the test-automation ADR.

### parameter `Test`

A Pester test object (a discovery-pass test, or an item of $result.Tests). Its .Tag and .Block chain carry the tags.

### outputs

`[string[]]` the distinct citations (e.g. 'ADR-PWSH-ERROR-THROWNOTWRITEERROR'), ordinally sorted (empty when none).

## Levels

The tag levels are the test's own tags, then each ancestor block with the root excluded. It is the same walk Get-TestBlockTag makes, but it
accumulates across every level instead of stopping at the first one that contributes. Provenance is a set, so a rule on a Describe and a
rule on an inner It both hold.

## Citation grammar

The grammar is strict and case-sensitive: only a well-formed rule code contributes. A miscased or malformed tag is Get-TestTagViolations'
concern, not a coverage row's.

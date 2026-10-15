---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-TestRuleTags.ps1.md
    kind: comment-page
    body_sha: fcbbd5d53589
    adrs:
      - ADR-PWSH-ERROR#3
---

# automation/Catzc.Base.QualityGates/private/Get-TestRuleTags.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The optional third tag dimension (provenance): which ADR rule(s) a test enforces, cited in the
[index](/docs/adr/index.md) '#' form (e.g. 'ADR-PWSH-ERROR#3'). Unlike the tier and category axes — single-valued
and
resolved nearest-contributing-block-wins (Get-TestBlockTag) — provenance is SET-VALUED and ADDITIVE: a
Describe may enforce a broad rule and an inner It a specific one, and both hold. So this UNIONS every
well-formed citation across the test's own It-tags and every ancestor block (root excluded), returning them
distinct and sorted. Only strictly well-formed 'ADR-<CODE>#<n>' citations contribute; a malformed one is
left for Get-TestTagViolations to reject rather than silently entering a coverage row. See the
test-automation ADR.
```

## comment:2

Section `.PARAMETER Test` of the comment-based help.

```text
A Pester test object (a discovery-pass test, or an item of $result.Tests). Its .Tag and .Block chain carry
the tags.
```

## comment:3

Above `$levels = [System.Collections.Generic.List[object]]::new()`.

```text
The tag levels to union: the test's own It-tags, then each ancestor block (root excluded) — the same walk
Get-TestBlockTag makes, but accumulating across every level instead of stopping at the first that
contributes, because provenance is a set (a Describe rule and an inner It rule both hold).
```

## comment:4

Above `if ($tag -cmatch '^ADR-[A-Z]+(?:-[A-Z]+)*#\d+$') {`.

```text
Strict, case-sensitive citation grammar: only a well-formed 'ADR-<CODE>#<n>' contributes. A
miscased or malformed tag is Get-TestTagViolations' concern, not a coverage row's.
```

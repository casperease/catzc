---
catzc:
  derived:
    path: docs/references/automation/catzc-base-docs/private/Get-AdrCitationGraphViolations.ps1.md
    kind: comment-page
    body_sha: "81694d4c7532"
    adrs: []
    links: []
---

# automation/Catzc.Base.Docs/private/Get-AdrCitationGraphViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A rule summary may cite only its own domain or a domain in its domain's depends_on list in adrs.yml. The list is read as declared,
not transitively: like the module dependency graph, it is an allow-list of direct edges, so a domain that cites another names it.
Body prose outside the rule registry may point anywhere and is not read here.

Two kinds of reference are read in every summary line (Get-AdrRuleSummaryLines):

  - a citation code, `ADR-<CODE>` or `ADR-<CODE>#<n>`, resolved to its domain through the registry (an External code, or a domain's
    code in a wildcard such as `ADR-<CODE>-*`); a code the registry does not know is left to Test-Links;
  - a markdown link whose target is a file under docs/adr/<domain>/ (Resolve-AdrLinkTarget).

Each line reports the domain it cites once, naming the first reference to it.

Private helper for Test-AdrRegistry; not exported.
```

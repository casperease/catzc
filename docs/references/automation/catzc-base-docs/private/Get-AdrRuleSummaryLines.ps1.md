# docs/references/automation/catzc-base-docs/private/Get-AdrRuleSummaryLines.ps1.md

`automation/Catzc.Base.Docs/private/Get-AdrRuleSummaryLines.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A rule summary is the body of a `### Rule <code>:<n>` entry in an ADR's rule registry: every line from the line after the heading
to the next heading. Blank lines, lines inside a fenced block, and the summary's own anchor bullets (`- [Section](#section)`, the
internal links to the prose that justifies the rule) are left out: what remains is the normative text. The rule is named in its
citation form, `<code>#<n>` ([ADR-REPO-LINK#5](/docs/adr/repository/markdown-links.md#rule-adr-repo-link5)).

Private helper for Test-AdrEngineNeutrality and the citation-graph check of Test-AdrRegistry; not exported.
```

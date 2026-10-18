# pwsh/Catzc.Base.Docs/types/AdrCitationRewriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Rewrites the ADR references in one file's text through a code map and a rule map: rule citations (ADR-<CODE>#<n>,
the heading's ADR-<CODE>:<n>, and the list continuation ADR-<CODE>#1, #5 and #7), bare codes, rule anchors
(rule-adr-<code><n>), markdown and code link destinations into docs/adr/, and plain path mentions of a moved ADR
file or folder. The rule map decides first (a rule that moves or collapses into another rule), then the code map
(a code renamed whole keeps its rule numbers). A link that carries a rule anchor follows the rule, possibly to
another file; any other link follows the file. A relative link is resolved at the file's own folder and written
back relative to it, so it stays correct at any depth
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)). Matching is exact, with a token
boundary on both sides, and runs everywhere in the text, fenced code blocks included. Pure: paths are
repository-relative and '/'-separated, so the result depends only on the text, the file's path, and the maps.
```

## comment:2

Above `public AdrCitationRewriter(IEnumerable codeRows, IEnumerable ruleRows,...`, written with `//`.

```text
codeRows: one dictionary per code-map row (old_code, new_code, old_path, new_path, kind; '-' for none), paths
relative to docs/adr/. ruleRows: one dictionary per rule-map row (old_rule, new_rule, kind), rules spelled
ADR-<CODE>:<n>. citations: the ADR index (Get-AdrCitationMap), which supplies the path of a rule's new code when
the code map does not name it; null when the code map names every path.
```

## comment:3

Above `string RewriteCitation(Match match)`, written with `//`.

```text
A citation and its list continuation, each rule mapped; an inherited '#<n>' stays bare while it keeps the code
of the citation before it and takes its own code when its rule moved elsewhere. Null when nothing changes, and
when a range (#1 to #6) holds a rule the rule map moves (SplitsRange reports it instead).
```

## comment:4

Above `bool SplitsRange(Match match)`, written with `//`.

```text
True when the citation's list holds a range (#1 to #6, #1–#6) that spans a rule the rule map moves: the range
cannot be rewritten endpoint by endpoint.
```

## comment:5

Above `string RewriteReference(string pathPart, string fragment, Form form, string...`, written with `//`.

```text
A path reference (pathPart, then '#' + fragment when one is given) mapped and written back in its own form;
null when it does not point into docs/adr/ or nothing changes.
```

## comment:6

Above `(string Path, string Fragment) MapTarget(string adrPath, string fragment,...`, written with `//`.

```text
The docs/adr-relative path and fragment a reference points to after the maps: a rule anchor follows its rule
(to the file of the rule's new code when the code changes); the path otherwise follows the file and folder map.
An in-file anchor of a page that is not the rule's ADR (a generated list with its own anchors) stays in-file.
```

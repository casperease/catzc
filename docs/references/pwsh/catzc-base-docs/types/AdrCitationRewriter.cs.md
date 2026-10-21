# pwsh/Catzc.Base.Docs/types/AdrCitationRewriter.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Rewrites the ADR references in one file's text through a code map and a rule map: ADR and rule codes (in a
citation or a `### Rule` heading alike), rule anchors (rule-adr-<code>-<name>), markdown and code link destinations
into docs/adr/, and plain path mentions of a moved ADR file or folder. The rule map decides first (a rule that
moves, collapses into another rule, or is renamed), then the code map: a moved ADR code carries every code below
it, each keeping the rest of its segments. A numbered citation or group names no rule and is reported Unhandled. A link that carries a rule anchor follows the rule, possibly to
another file; any other link follows the file. A relative link is resolved at the file's own folder and written
back relative to it, so it stays correct at any depth
([ADR-REPO-LINK-MARKDOWNRELATIVE](/docs/adr/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). Matching is exact, with a token
boundary on both sides, and runs everywhere in the text, fenced code blocks included. Pure: paths are
repository-relative and '/'-separated, so the result depends only on the text, the file's path, and the maps.
```

## comment:2

Above `public AdrCitationRewriter(IEnumerable codeRows, IEnumerable ruleRows,...`, written with `//`.

```text
codeRows: one dictionary per code-map row (old_code, new_code, old_path, new_path, kind; '-' for none), paths
relative to docs/adr/. ruleRows: one dictionary per rule-map row (old_rule, new_rule, kind), each a rule's code. citations: the ADR index (Get-AdrCitationMap), which supplies the path of a rule's new code when
the code map does not name it; null when the code map names every path.
```

## comment:3

Above `string RewriteReference(string pathPart, string fragment, Form form, string...`, written with `//`.

```text
A path reference (pathPart, then '#' + fragment when one is given) mapped and written back in its own form;
null when it does not point into docs/adr/ or nothing changes.
```

## comment:4

Above `(string Path, string Fragment) MapTarget(string adrPath, string fragment,...`, written with `//`.

```text
The docs/adr-relative path and fragment a reference points to after the maps: a rule anchor follows its rule
(to the file of the rule's new ADR when its ADR changes); the path otherwise follows the file and folder map.
An in-file anchor of a page that is not the rule's ADR (a generated list with its own anchors) stays in-file.
```

## comment:5

Above `public AdrCitationRewriter(IEnumerable codeRows, IEnumerable ruleRows,...`, written with `//`.

```text
treeFiles are the repository-relative paths of the files under docs/adr in the tree, before or after a folder moves;
kinds are the record kinds the registry declares (AdrsConfig.Kinds), old and new codes alike.
```

## comment:6

Above `readonly string anchorPattern;`, written with `//`.

```text
The code grammar over the registered record kinds, the markers of a code
([ADR-REPO-ADRCODE-PATHOFSEGMENTS](/docs/adr/repository/adr-code-language.md#rule-adr-repo-adrcode-pathofsegments)).
```

## comment:7

Above `codeShape = new Regex("^" + upper + @"(?:-[A-Z][A-Z0-9]*)*$",...`, written with `//`.

```text
A new code may be a bare kind: a framing domain's code becomes its kind
([ADR-REPO-ADRCODE-DOMAINSEGMENT](/docs/adr/repository/adr-code-language.md#rule-adr-repo-adrcode-domainsegment)).
```

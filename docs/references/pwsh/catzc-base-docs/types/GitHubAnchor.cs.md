# pwsh/Base.Docs/types/GitHubAnchor.cs

GitHub's heading anchors: the slug GitHub renders for a markdown heading, and the full anchor set of a markdown document, which is what a
link's `#fragment` must name to resolve on GitHub
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)).

## The slug

The slug follows GitHub's rendered-text algorithm:

- inline markup is reduced to its text: code-span backticks dropped, a link to its text, emphasis asterisks dropped;
- the text is lowercased;
- every character that is not a letter, digit, space, hyphen or underscore is removed;
- each space becomes a hyphen.

## The anchor set

`Anchors` returns every anchor a markdown document exposes: heading slugs plus explicit HTML anchors (`<a id="…">` or `<a name="…">`).
Duplicate headings in one document take `-1`, `-2`, … suffixes in document order. Headings inside fenced code blocks are not headings.

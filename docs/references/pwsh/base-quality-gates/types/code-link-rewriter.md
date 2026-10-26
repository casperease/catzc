# pwsh/Base.QualityGates/types/CodeLinkRewriter.cs

Rewrites the decision-record references in one comment into canonical code links
([ADR-REPO-LINK-CODELINKS](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-codelinks)). It is pure: it returns the new
comment text and reports what it found at comment-relative offsets, and the link engine owns files and positions.

## Canonical forms

A whole decision record becomes `[ADR-<CODE>](<path>.md)` and one rule becomes `[ADR-<CODE>-<NAME>](<path>.md#rule-adr-<code>-<name>)`.
Every other spelling is recognised: a bare, `./`, `../` or rooted `docs/drs` path, an ADR file name alone, a bare citation, a path followed
by its own citation, and a markdown link in another shape. A numbered citation is reported, since it names no rule.

The citation code is the source of truth. The destination is derived from it (`DrsCitationMap`), so a stale path is re-pointed and a text
and destination mismatch resolves in favour of the code. Inline code spans and the `.EXAMPLE` sections of a PowerShell help block are
literal and never touched.

## Matching

One pattern reads a reference, and its alternation order matters: an existing link swallows the citation in its text.

- A path or file name starts a word: it follows the comment start, a space or opening punctuation, never another character, so
  `<root>/docs/drs/index.md` is a placeholder path, not a reference.
- A citation is not glued to a word. A `-` before it is allowed only after a digit, as a range or date dash is.
- A meta head is derived front matter: its `adrs` list holds the file's codes as plain codes, never as links.
- The citation right after a path (`x.md (ADR-X-NAME)`, `x.md, Rule ADR-X-NAME`) merges into the path's link. The method returns how many
  characters it covers, and takes a closing parenthesis only when the separator opened it.
- A bracketed link right after a bare citation that names the same record or rule is the same reference spelled twice. It merges into the
  citation's one canonical link, even when the link sits on the next line, and a link that points elsewhere is left alone.

## Calling it

`Rewrite` takes one comment and returns the new text, appending the hits and the inserted link texts. Test files pass
`tolerateUnknownCodes`, which skips citations of unregistered codes, because test comments name fixture records on purpose.

The constructor takes the registry, for its code grammar over the registered kinds and its root, and `anchorsOf`, which maps a
repository-relative `.md` path to its GitHub anchors (null when the file does not exist).

## Edges

Each reference is recorded as an `EdgeHit`: one relation the text holds, at a text-relative offset, with the target a repository path
([ADR-REPO-LINKS-EVERYLINKHASADIRECTION](../../../../drs/repository/links-in-repository.md#rule-adr-repo-links-everylinkhasadirection)). A
decision record reference is its canonical link's target. Any other link names the file it resolves to, from the comment's own folder or
rooted, and only when that file exists: a URL, an anchor, a folder and a missing target are no relation.

# pwsh/Base.QualityGates/types/MarkdownLinkScanner.cs

Checks and aligns the markdown links of one `.md` file
([ADR-REPO-LINK-MARKDOWNRELATIVE](../../../../drs/repository/markdown-links.md#rule-adr-repo-link-markdownrelative)). A markdown link is
relative to its own file: a repository-rooted link is rewritten relative, and a rule citation spelled `ADR-X:n` in prose becomes `ADR-X#n`,
since the `:` form lives only in a rule's own `### Rule` heading. Fenced code blocks and inline code spans are literal. The scanner is pure
apart from the existence checks it makes against the repository on disk.

## Reported, not fixable

- a target that does not exist;
- a `#fragment` naming no heading or anchor of its target;
- a relative link that climbs above the repository root;
- an absolute URL into this repository outside `.github/`;
- a target that exists on disk but is not committed, when the tracked paths are given: GitHub, which renders these links, does not have it.

Code links are not checked this way, because no hosted renderer follows a comment.

## Construction and scan

The constructor takes `codeForm`, the code grammar over the registered kinds, which the numbered-citation check matches, and:

- `selfUrlPrefix`: this repository's web URL (`https://github.com/<owner>/<repo>`), or null to skip that check;
- `trackedFiles`: the repository-relative paths git tracks, or null to skip the tracked check, as for a scratch root that is not a git work
  tree. A folder counts as tracked when any tracked file lies under it.

`Scan` takes one markdown file's text (`repoPath` is repository-relative and `/`-separated) and returns the aligned text. Hits are appended
at absolute offsets into the original text.

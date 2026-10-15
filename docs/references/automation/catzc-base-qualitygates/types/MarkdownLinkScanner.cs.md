---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/types/MarkdownLinkScanner.cs.md
    kind: comment-page
    body_sha: "0470b07ea2fa"
    adrs:
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.QualityGates/types/MarkdownLinkScanner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
Checks and aligns the markdown links of one .md file
([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2), #5, #7). A markdown link is relative to its
own file: a repository-rooted link is rewritten relative, and a rule citation spelled `ADR-X:n` in prose becomes
`ADR-X#n` (the ':' form lives only in a rule's own '### Rule' heading). Reported, not fixable: a target that does
not exist, a #fragment naming no heading or anchor of its target, a relative link that climbs above the
repository root, and an absolute URL into this repository outside .github/. Fenced code blocks and inline code
spans are literal. Pure apart from the existence checks it makes against the repository on disk. Given the tracked
paths, a target that exists on disk but is not committed is reported too: GitHub, which renders these links, does not
have it. Code links are not checked this way — no hosted renderer follows a comment.
```

## comment:2

Above `public MarkdownLinkScanner(string repositoryRoot, Func<string,...`.

```text
selfUrlPrefix: this repository's web URL (https://github.com/<owner>/<repo>), or null to skip that check.
trackedFiles: the repository-relative paths git tracks, or null to skip the tracked check (a scratch root that is
not a git work tree). A folder counts as tracked when any tracked file lies under it.
```

## comment:3

Above `public string Scan(string text, string repoPath, List<CodeLinkRewriter.Hit>...`.

```text
Scans one markdown file (repoPath is repository-relative, '/'-separated). Returns the aligned text; hits are
appended at absolute offsets into the original text.
```

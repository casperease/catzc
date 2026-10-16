---
catzc:
  immutable:
    with_body_sha: "70e6dc39258d"
    path: docs/references/automation/catzc-base-qualitygates/types/MarkdownLinkScanner.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: markdown-link-scanner-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-REPO-LINK#2
---

# automation/Catzc.Base.QualityGates/types/MarkdownLinkScanner.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

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

Above `public MarkdownLinkScanner(string repositoryRoot, Func<string,...`, written with `//`.

```text
selfUrlPrefix: this repository's web URL (https://github.com/<owner>/<repo>), or null to skip that check.
trackedFiles: the repository-relative paths git tracks, or null to skip the tracked check (a scratch root that is
not a git work tree). A folder counts as tracked when any tracked file lies under it.
```

## comment:3

Above `public string Scan(string text, string repoPath, List<CodeLinkRewriter.Hit>...`, written with `//`.

```text
Scans one markdown file (repoPath is repository-relative, '/'-separated). Returns the aligned text; hits are
appended at absolute offsets into the original text.
```

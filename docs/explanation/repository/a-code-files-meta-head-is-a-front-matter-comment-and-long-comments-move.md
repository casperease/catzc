---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-CODEMETA-CODEFILEHEAD
      - ADR-REPO-COMMENTS-MOVEDBYTOOL
---

# A code files meta head is a front matter comment and long comments move (ADR-REPO-CODEMETA-CODEFILEHEAD + ADR-REPO-COMMENTS-MOVEDBYTOOL)

This article is one rule: [ADR-REPO-CODEMETA-CODEFILEHEAD](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead) and
[ADR-REPO-COMMENTS-MOVEDBYTOOL](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-movedbytool) merged into one. It holds
nothing beyond what those two rules say.

A code file whose head policy calls for a meta block carries it as a meta head: one comment at the top of the file whose text is a front
matter document, the same `catzc:` block a Markdown file carries. Long comments are moved by tool and checked by a gate: `Export-Comments`
moves every long comment in scope, `Format-Code` runs it as its `comments` step, and `Test-Comments` fails on a long comment left in a file.

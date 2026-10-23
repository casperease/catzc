---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-COMMENTS-MOVELOSESNOTHING
      - ADR-REPO-CODEMETA-IMPRINTSTEP
---

# Moving a comment loses nothing and format code writes the head as an imprint step

This article is one rule:
[ADR-REPO-COMMENTS-MOVELOSESNOTHING](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-movelosesnothing) and
[ADR-REPO-CODEMETA-IMPRINTSTEP](../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-imprintstep) merged into one. It holds nothing
beyond what those two rules say.

The move of a comment to its page loses nothing: each moved comment becomes one section, `## comment:<n>`, holding its lines exactly as they
stood, with comment markers and common indent removed, inside a fenced `text` block so no formatter rewrites them. `Format-Code` writes the
head the same way, as a global imprint step listed once in the file-language registry, so it runs after the formatter of every language.

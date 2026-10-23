---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-COMMENTS-INLINEVIEWGENERATED
      - ADR-REPO-SLIDES-TIMEAXIS
---

# The inline comment view is generated and a time axis is declared in shorthand

This article is one rule:
[ADR-REPO-COMMENTS-INLINEVIEWGENERATED](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-inlineviewgenerated) and
[ADR-REPO-SLIDES-TIMEAXIS](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-timeaxis) merged into one. It holds nothing
beyond what those two rules say.

The file with its comments inline is a generated view, never a second copy kept by hand: `Build-CommentView` writes it under `out/` from the
file and its page. A diagram that runs along time declares it in shorthand and put writes the shorthand out: a lane is a band of numbered
steps, and a rule is a gate line across the lanes after a step.

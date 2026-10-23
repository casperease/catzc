---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-COMMENTS-INLINEVIEWGENERATED
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# The inline comment view is generated and every file has a head policy (ADR-REPO-COMMENTS-INLINEVIEWGENERATED + ADR-REPO-FILEMETA-HEADPOLICY)

This article is one rule:
[ADR-REPO-COMMENTS-INLINEVIEWGENERATED](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-inlineviewgenerated) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

The file with its comments inline is a generated view, never a second copy kept by hand: `Build-CommentView` writes it under `out/`, at the
file's repository path, from the file and its page, putting every section back above the code line it names as line comments. Every file on
disk is format-managed in the same way: a `Format-*` command covers it and decides its head policy, whether it carries one meta block and
which.

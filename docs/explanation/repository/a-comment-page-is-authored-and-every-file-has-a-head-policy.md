---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-COMMENTS-PAGEISAUTHORED
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# A comment page is authored and every file has a head policy

This article is one rule: [ADR-REPO-COMMENTS-PAGEISAUTHORED](../../drs/repository/comments-in-docs.md#rule-adr-repo-comments-pageisauthored)
and [ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing
beyond what those two rules say.

A comment page is an authored file: its `## comment:<n>` sections are the exporter's to append and the author's to edit, and the page of a
PowerShell function file or script also holds the file's help in a `## help` section. Every file on disk is format-managed: a `Format-*`
command covers it and decides its head policy, whether it carries one meta block and which.

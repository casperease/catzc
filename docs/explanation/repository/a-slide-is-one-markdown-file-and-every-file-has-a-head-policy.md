---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-REPO-SLIDES-SLIDEFILE
      - ADR-REPO-FILEMETA-HEADPOLICY
---

# A slide is one markdown file and every file has a head policy

This article is one rule: [ADR-REPO-SLIDES-SLIDEFILE](../../drs/repository/slides-as-markdown.md#rule-adr-repo-slides-slidefile) and
[ADR-REPO-FILEMETA-HEADPOLICY](../../drs/repository/file-meta.md#rule-adr-repo-filemeta-headpolicy) merged into one. It holds nothing beyond
what those two rules say.

A slide file is one markdown file per slide, `<stem>.slide.md`, in a deck folder `docs/explanation/<domain>/<deck>/` beside the deck file,
`deck.md`, which names the deck's title and its sections; the slide's level-one heading is its title and each level-two heading is a field
the slide's pattern fills. Every file on disk is format-managed, a `Format-*` command covering it and deciding its head policy.

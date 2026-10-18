---
catzc:
  immutable:
    repo_status: clean
    path: docs/explanation/thesis/product-thesis/citing.slide.md
    folder: docs/explanation/thesis/product-thesis
    name: citing-slide
    filetype: md
    role: slide
    language: markdown
    track: docs
    tracktype: documentation
  config:
    pattern: rule
    deck: product-thesis
    order: 20
---

# Every rule has one code

## Eyebrow

How the rules are cited

## Body

Every ADR opens with a numbered rule registry, and a rule is cited as its ADR code, a literal ADR prefix plus uppercase segments, then a
hash and the rule's number. The prefix is the single searchable marker for a rule reference anywhere in the repository.

A rule's number is stable. A retired rule's number is never reused, so a citation never changes its meaning when a neighbouring rule goes.

## Notes

This is what lets a slide, a comment or a test tag point at one rule and stay right. The deck's own slides carry their codes in the eyebrow.

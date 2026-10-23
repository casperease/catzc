---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AUTO-ACCOSTED-ARTICLERENDERING
      - ADR-AUTO-BUNDLE-IMMUTABLEBUILD
---

# An article fragment is a rendering and the build is immutable and content addressed (ADR-AUTO-ACCOSTED-ARTICLERENDERING + ADR-AUTO-BUNDLE-IMMUTABLEBUILD)

This article is one rule:
[ADR-AUTO-ACCOSTED-ARTICLERENDERING](../../drs/automation/accosted-language.md#rule-adr-auto-accosted-articlerendering) and
[ADR-AUTO-BUNDLE-IMMUTABLEBUILD](../../drs/automation/platform-bundle.md#rule-adr-auto-bundle-immutablebuild) merged into one. It holds
nothing beyond what those two rules say.

A PowerShell fragment in an article is a rendering of the contract form, produced from the one reader's record by one function in
`Catzc.Base.Docs`, never written by hand: `Get-FileLanguage -Path README.md` renders `get_file_language: { path: README.md }`. The same
discipline holds for the build, which is immutable and content-addressed, so the same commit yields a byte-identical result.

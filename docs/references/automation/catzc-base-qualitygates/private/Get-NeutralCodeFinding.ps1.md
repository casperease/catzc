---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-NeutralCodeFinding.ps1.md
    kind: comment-page
    body_sha: "9652570d923d"
    adrs:
      - ADR-AUTO-TEST#3
    links: []
---

# automation/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The neutral-code check of Test-SourceConventions
([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)): a logic test owns its inputs and
uses identities that cannot collide with the real ones, so an L0 test's fixture data names neutral codes (a
widget or gadget code), never a code the ADR index declares. The real codes come from the caller, read from the ADR
registry, so nothing here names one.

It reads the file's syntax tree, never runs Pester. A string literal is checked when the nearest Describe,
Context, or It around it that carries a tier tag carries L0 — or, outside every tier-tagged block, when L0 is the
only tier the file carries. The values of a -Tag argument are citations, not data, and are never checked; the
title of a Describe, Context, or It (its -Name, given by name or by position) is a name, not data, so it is never
checked either; comments (code links included) are not part of the syntax tree, so they never are.
```

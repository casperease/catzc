---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-inspiration/Get-Inspiration.ps1.md
    kind: comment-page
    body_sha: "612c2f1a1593"
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-INSPIRE#1
      - ADR-REPO-INSPIRE#2
---

# automation/Catzc.Tooling.Inspiration/Get-Inspiration.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the inspirations from configs/inspiration.yml (Get-Config -Config inspiration, whose type declares the sensible
default, the one 'eac' entry; [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)),
resolves each root on this machine (Resolve-InspirationRoot), and returns one Inspiration record per pick: Id, Root,
Available, Description, Paths.

An inspiration is read for ideas, never as a reference implementation
([ADR-REPO-INSPIRE#2](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire2)), and the work carries on without
one that is absent ([ADR-REPO-INSPIRE#1](/docs/adr/repository/inspiration.md#rule-adr-repo-inspire1)). So an
inspiration whose root does not exist here is reported with Available false, never thrown on.

  - No arguments: every available inspiration, in file order.
  - -Id: that inspiration, available or not; an unknown id throws.
  - -Count: that many distinct inspirations at random, from the available ones (every one with
    -IncludeUnavailable), clamped to how many there are. -Seed makes the pick deterministic.
```

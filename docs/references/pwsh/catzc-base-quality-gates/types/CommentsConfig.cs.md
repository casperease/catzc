# pwsh/Catzc.Base.QualityGates/types/CommentsConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
The comment-page settings (configs/comments.yml), and the single declaration of their sensible defaults: every
key is optional, and an omitted key — or a fresh checkout with no file — behaves exactly like the default, so no
function restates a value ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
A file carries no long comment and the prose lives in the file's comment page, so each has one living copy
([PDR-ONELIVE-ONEVERSION](/docs/adr/principles/one-living-version.md#rule-pdr-onelive-oneversion)); what moves and where it
goes are configured here, not programmed
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/adr/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
  languages        — the file languages (languages.yml names) whose files carry comment pages; the comment syntax
                     itself is CommentLexer's, the one place that knows it
  min_lines        — a comment block with fewer prose lines than this stays in the file (default 2)
  keep             — per language, the comment lines that never move: a prefix of a trimmed comment line (the
                     marker included for a line comment), which stays in place wherever it sits in a run and splits
                     the run around it, or a comment-based help keyword (`.SYNOPSIS`) naming a section whose body
                     stays whole; a language given here replaces its default list
  exclude          — repository-relative glob (the durable-sha-globs dialect) -> why its files keep their comments:
                     a test's prose is its own subject, and an asset is copied or published verbatim elsewhere, where a
                     page of this repository would be foreign; a key given here replaces the default map
  view             — the gitignored folder, under out/, the annotated view is written to
                     ([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction))
Property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```

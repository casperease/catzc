# pwsh/Base.QualityGates/types/CommentsConfig.cs

The typed record for `configs/comments.yml`, the comment-page settings, and the single declaration of their sensible defaults. Every key is
optional, and an omitted key, or a fresh checkout with no file, behaves exactly like the default, so no function restates a value
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). A file
carries no long comment and the prose lives on its comment page, so each has one living copy
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). What moves and where it goes are
configured here, not programmed
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
Property names mirror the YAML keys
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).

## Keys

An unknown key throws.

- **`languages`** — the file languages (`languages.yml` names) whose files carry comment pages. The comment syntax itself is
  `CommentLexer`'s. The default lists `powershell`, `yaml`, `pipeline-yaml`, `bcl` and `bicep`.
- **`min_lines`** — a comment block with fewer prose lines than this stays in the file. A positive integer, default 2.
- **`keep`** — per language, the comment lines that never move. An entry is a prefix of a trimmed comment line (the marker included for a
  line comment), which stays in place wherever it sits in a run and splits the run around it, or a comment-based help keyword such as
  `.SYNOPSIS` naming a section whose body stays whole. A language given here replaces its default list.
- **`keep_run`** — per language, per language, the heads (prefixes of a trimmed comment line, case-insensitive) that start a comment run
  which stays whole in the file, such as the meta head. It defaults to none.
- **`exclude`** — a repository-relative glob (the durable-sha-globs dialect) mapped to why its files keep their comments. A test's prose is
  its own subject, and an asset is copied or published verbatim elsewhere, where a page of this repository would be foreign. A key given
  here replaces the default map.
- **`view`** — the gitignored folder, under `out/`, that the annotated view is written to, `out/annotated` by default
  ([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)).

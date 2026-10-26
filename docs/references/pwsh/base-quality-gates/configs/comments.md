# pwsh/Base.QualityGates/configs/comments.yml

The settings for the comment pages: what Export-Comments moves out of a file, what stays, and where Build-CommentView writes its view.
Test-Comments reads the same settings.

## Why it exists

A file carries no long comment. The prose lives in the file's comment page under `docs/references`, and the file's head names the page, so
each comment has exactly one living copy
([PDR-ONELIVE-ONEVERSION](../../../../drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). The comment syntax of each
language is CommentLexer's, the one place that knows it. This file decides what moves and where it goes
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](../../../../drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).

## Keys

Every key is optional. An omitted key takes the sensible default declared once on `Catzc.Base.QualityGates.CommentsConfig`
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](../../../../drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).

- `languages`: the file languages (the `languages.yml` names) whose files carry comment pages. A language CommentLexer cannot read, such as
  python or bash, is out until the lexer learns it. Default: powershell, yaml, pipeline-yaml, bcl, bicep.
- `min_lines`: a comment block with fewer prose lines than this stays in the file. Default: 2.
- `keep`: per language, the comment lines that never move. An entry is a prefix of a trimmed comment line, marker included for a line
  comment, which stays in place wherever it sits in a run and splits the run around it. Or it is a comment-based help keyword naming a
  section whose body stays whole. A language listed here replaces its default list, and an unlisted language keeps the default. Tool
  directives such as `cspell:` stay with the code they govern.
- `keep_run`: a head listed here keeps the whole run of comment lines it opens, which is how the meta head stays in the file
  ([ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD](../../../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-commentsleavehead)).
- `exclude`: file kinds that keep their comments, each with the reason, where a kind is a kind or `kind/subkind` of the file-kinds registry.
  An asset is copied or published verbatim elsewhere, such as a root-config template, the hook's C# source or a standalone script, where a
  page of this repository would be foreign. Listing this key replaces the default map, so the shipped file lists exactly its two entries,
  `asset` and `fixture/input`, and a test's prose moves to a comment page like any other file's.
- `view`: the gitignored folder, under `out/`, that Build-CommentView writes the annotated view to. Default: `out/annotated`
  ([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](../../../../drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)).

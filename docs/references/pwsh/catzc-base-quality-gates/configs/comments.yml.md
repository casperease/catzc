# pwsh/Catzc.Base.QualityGates/configs/comments.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `languages: [powershell, yaml, pipeline-yaml, bcl, bicep]`, written with `#`.

```text
Comment-page settings for Export-Comments / Build-CommentView / Test-Comments.

A file carries no long comment — the prose lives in the file's comment page under docs/references, and the file's
head names the page, so each comment has exactly one living copy
([PDR-ONELIVE-ONEVERSION](/docs/drs/principles/one-living-version.md#rule-pdr-onelive-oneversion)). Every key is optional:
an omitted key takes the sensible default declared once on Catzc.Base.QualityGates.CommentsConfig
([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)). The comment syntax of
each language is CommentLexer's, the one place that knows it; this file decides what moves and where it goes
([PDR-CONFIG-VARYINGBEHAVIOURISCONFIG](/docs/drs/principles/configure-not-program.md#rule-pdr-config-varyingbehaviourisconfig)).
```

## comment:2

Above `languages: [powershell, yaml, pipeline-yaml, bcl, bicep]`, written with `#`.

```text
The file languages (languages.yml names) whose files carry comment pages. A language CommentLexer cannot read
(python, bash) is out until the lexer learns it. Default: powershell, yaml, pipeline-yaml, bcl, bicep.
```

## comment:3

Above `keep:`, written with `#`.

```text
Per language, the comment lines that never move: a prefix of a trimmed comment line (marker included for a line
comment), which stays in place wherever it sits in a run and splits the run around it, or a comment-based help
keyword naming a section whose body stays whole. A language listed here replaces its default list; an unlisted
language keeps the default. Tool directives (`cspell:`) stay with the code they govern.
```

## comment:4

Above `keep_run:`, written with `#`.

```text
A head listed here keeps the whole run of comment lines it opens, which is how the meta head stays in the file.
[ADR-REPO-CODEMETA-COMMENTSLEAVEHEAD](/docs/drs/repository/code-file-meta.md#rule-adr-repo-codemeta-commentsleavehead)
```

## comment:5

Above `exclude:`, written with `#`.

```text
Files that keep their comments: repository-relative glob (the durable-sha-globs dialect) -> why. An asset is copied or
published verbatim elsewhere (a root-config template, the hook's C# source, a standalone script), where a page of this
repository would be foreign. A test is not listed, so its prose moves to a comment page like any other file's. Listing this key replaces
the default map, so only the asset entry is kept.
```

## comment:6

Above `view: out/annotated`, written with `#`.

```text
The gitignored folder, under out/, Build-CommentView writes the annotated view to
([ADR-REPO-OUTDIR-OUTPUTROOTFUNCTION](/docs/drs/repository/dedicated-output-directory.md#rule-adr-repo-outdir-outputrootfunction)).
```
